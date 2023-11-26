//
//  KYNearbyServiceConstants.swift
//  KYNearbyService
//
//  Created by Kjuly on 11/1/2021.
//  Copyright © 2021 Kjuly. All rights reserved.
//

import Foundation

// MARK: - Notification Name

extension Notification.Name {

  public enum KYNearbyService {

    // MARK: - Public Notification Name for Peer Display Name

    /// Should send resource.
    public static let didUpdatePeerDisplayName = Notification.Name("com.kjuly.KYNearbyService.DidUpdatePeerDisplayName")

    // MARK: - Public Notification Name for Resource

    /// Should send resource.
    public static let shouldSendResource = Notification.Name("com.kjuly.KYNearbyService.ShouldSendResource")
    /// Did start receiving resource.
    public static let didStartReceivingResource = Notification.Name("com.kjuly.KYNearbyService.StartReceivingResource")
    /// Did receive resource.
    public static let didReceiveResource = Notification.Name("com.kjuly.KYNearbyService.DidReceiveResource")

    // MARK: - Internal Notification Name

    /// Peer Did Change State
    static let peerDidChangeState = Notification.Name("com.kjuly.KYNearbyService.PeerDidChangeState")
    /// Browser Found Peer
    static let foundPeer = Notification.Name("com.kjuly.KYNearbyService.FoundPeer")
    /// Browser Lost Peer
    static let lostPeer = Notification.Name("com.kjuly.KYNearbyService.LostPeer")
    /// Browsing Error
    static let browsingError = Notification.Name("com.kjuly.KYNearbyService.BrowsingError")
  }
}

// MARK: - Notification UserInfo Key

public enum KYNearbyServiceNotificationUserInfoKey {
  public static let peerID = "peer_id"
  public static let peerItem = "peer_item"
  public static let state = "state"
  public static let filename = "filename"
  public static let url = "url"
  public static let extraActionInfo = "extra_action_info"
  public static let errorMessage = "error_msg"
}

// MARK: - Peer Connection Status

public enum KYNearbyPeerConnectionStatus: Int {
  /// Not connected to the session.
  case notConnected = 0
  /// Peer is connecting to the session.
  case connecting
  /// Peer is connected to the session.
  case connected
  /// Peer is declined to the session.
  case declined
  /// Peer is blocked to the session (unlocked until next session).
  case blocked

  var text: String {
    switch self {
    case .notConnected: return "LS:Connection Status:Not Connected".ky_nearbyServiceLocalized
    case .connecting: return "LS:Connection Status:Connecting".ky_nearbyServiceLocalized
    case .connected: return "LS:Connection Status:Connected".ky_nearbyServiceLocalized
    case .declined: return "LS:Connection Status:Declined".ky_nearbyServiceLocalized
    case .blocked: return "LS:Connection Status:Blocked".ky_nearbyServiceLocalized
    }
  }
}

// MARK: - Peer Process Status

@objc
public enum KYNearbyPeerProcessStatus: Int {
  case none = 0
  case pending
  case processing
}
