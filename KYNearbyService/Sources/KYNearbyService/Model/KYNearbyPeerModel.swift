//
//  KYNearbyPeerModel.swift
//  KYNearbyService
//
//  Created by Kjuly on 16/11/2020.
//  Copyright © 2020 Kjuly. All rights reserved.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

@objc
public class KYNearbyPeerModel: NSObject, ObservableObject {

  /// Peer ID of the user nearby.
  public let peerID: MCPeerID
  /// Display name for the peer.
  @objc public let displayName: String

  /// Whether this peer is visible to others (note: invisible peer will also be presented if it's connected).
  var isVisibleToOthers: Bool

  /// The connection status.
  @Published public internal(set) var connectionStatus: KYNearbyPeerConnectionStatus

  /// Current process status.
  @Published @objc public var processStatus: KYNearbyPeerProcessStatus = .none
  @objc public var processTitle: String?
  @Published @objc public var processErrorMessage: String?

  @Published @objc public dynamic var progressCounter: Int = 0
  var observation: NSKeyValueObservation?

  @objc public weak var progress: Progress? {
    didSet {
      if self.observation != nil {
        self.observation?.invalidate()
        self.observation = nil
      }

      if self.progress == nil {
        return
      }
      self.observation = self.progress?.observe(
        \.fractionCompleted,
         options: .new,
         changeHandler: { [weak self] (_: Progress, change: NSKeyValueObservedChange<Double>) in
           let fractionCompleted: Double = change.newValue ?? 0
           let progressCounter: Int = Int(round(fractionCompleted * 100))

           if self?.progressCounter != progressCounter {
             DispatchQueue.main.async {
               self?.progressCounter = progressCounter
             }
           }
         })
    }
  }

  // MARK: - Deinit

  deinit {
    self.observation?.invalidate()
    self.progress = nil
  }

  // MARK: - Init

  @MainActor
  init(
    peerID: MCPeerID,
    isVisibleToOthers: Bool,
    connectionStatus: KYNearbyPeerConnectionStatus
  ) {
    self.peerID = peerID
    self.displayName = peerID.displayName

    self.isVisibleToOthers = isVisibleToOthers
    self.connectionStatus = connectionStatus
  }

  // MARK: - Public

  public func matchesWithPeerID(_ peerID: MCPeerID?) -> Bool {
    guard let peerID else {
      return false
    }
    return self.peerID.isEqual(peerID)
  }

  @MainActor
  public func updateState(with sessionState: MCSessionState) {
    switch sessionState {
    case .notConnected: self.connectionStatus = .notConnected
    case .connecting: self.connectionStatus = .connecting
    case .connected: self.connectionStatus = .connected
    default:
      self.connectionStatus = .notConnected
    }
  }

  @MainActor
  @objc
  public func prepareForProcessing() {
    self.processStatus = .pending
  }

  @MainActor
  @objc
  public func startProcessing(forReceiving: Bool) {
    self.processStatus = .processing

    let processTitle = (forReceiving ? "LS:Receiving..." : "LS:Sending...").ky_nearbyServiceLocalized
    if self.processTitle != processTitle {
      self.processTitle = processTitle
    }

    if self.processErrorMessage != nil {
      self.processErrorMessage = nil
    }

    if self.progress != nil {
      self.progress?.cancel()
      self.progress = nil
    }
    self.progressCounter = 0
  }

  @MainActor
  @objc
  public func doneProcessing(with errorMessage: String?) {
    self.processStatus = .none
    self.processErrorMessage = errorMessage
    self.progress = nil
  }
}

// MARK: - NSCopying
/*
extension KYNearbyPeerModel: NSCopying {

  @MainActor
  public func copy(with zone: NSZone? = nil) -> Any {
    let copy = KYNearbyPeerModel(
      peerID: self.peerID,
      isVisibleToOthers: self.isVisibleToOthers,
      connectionStatus: self.connectionStatus)

    copy.processStatus = self.processStatus
    copy.processTitle = self.processTitle
    copy.processErrorMessage = self.processErrorMessage

    copy.progressCounter = self.progressCounter
    copy.progress = self.progress

    return copy
  }
}*/
