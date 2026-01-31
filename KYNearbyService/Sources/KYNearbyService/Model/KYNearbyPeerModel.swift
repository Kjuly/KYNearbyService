//
//  KYNearbyPeerModel.swift
//  KYNearbyService
//
//  Created by Kjuly on 16/11/2020.
//  Copyright © 2020 Kjuly. All rights reserved.
//

import SwiftUI
import MultipeerConnectivity

public class KYNearbyPeerModel: NSObject, ObservableObject, @unchecked Sendable {

  /// Peer ID of the user nearby.
  public let peerID: MCPeerID
  /// Display name for the peer.
  public let displayName: String

  /// Whether this peer is visible to others (note: invisible peer will also be presented if it's connected).
  var isVisibleToOthers: Bool

  /// The connection status.
  @Published public internal(set) var connectionStatus: KYNearbyPeerConnectionStatus

  /// Current process status.
  @Published public var processStatus: KYNearbyPeerProcessStatus = .none
  public var processTitle: String?
  @Published public var processErrorMessage: String?

  @Published public dynamic var progressCounter: Int = 0
  var observation: NSKeyValueObservation?

  public weak var progress: Progress? {
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
         options: .new
      ) { [weak self] (_: Progress, change: NSKeyValueObservedChange<Double>) in

        let fractionCompleted: Double = change.newValue ?? 0
        let progressCounter: Int = Int(round(fractionCompleted * 100))
        DispatchQueue.main.async { [weak self] in
          guard let self, self.progressCounter != progressCounter else {
            return
          }
          self.progressCounter = progressCounter
        }
      }
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
  public func prepareForProcessing() {
    self.processStatus = .pending
  }

  @MainActor
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
