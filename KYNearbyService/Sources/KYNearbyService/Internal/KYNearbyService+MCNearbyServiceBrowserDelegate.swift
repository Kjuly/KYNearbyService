//
//  KYNearbyService+MCNearbyServiceBrowserDelegate.swift
//  KYNearbyService
//
//  Created by Kjuly on 8/2/2022.
//  Copyright © 2022 Kaijie Yu. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import KYLogger

extension KYNearbyService: MCNearbyServiceBrowserDelegate {

  // Found a nearby advertising peer.
  public func browser(
    _ browser: MCNearbyServiceBrowser,
    foundPeer peerID: MCPeerID,
    withDiscoveryInfo info: [String: String]?
  ) {
    KYLog(.debug, "* FOUND PEER: \(peerID)")
    let peerName = peerID.displayName
    if peerName.isEmpty || peerName == self.peerID?.displayName {
      return
    }

    if let item: KYNearbyPeerModel = p_getItem(with: peerID) {
      if !item.isVisibleToOthers {
        item.isVisibleToOthers = true
      }
    } else {
      // Check whether the new peer has been connected already.
      var newItemState: KYNearbyPeerConnectionStatus
      if
        let session = self.session,
        session.connectedPeers.contains(where: { peerName == $0.displayName })
      { // swiftlint:disable:this opening_brace
        newItemState = .connected
      } else {
        newItemState = .notConnected
      }

      DispatchQueue.main.async {
        let newItem = KYNearbyPeerModel(peerID: peerID, isVisibleToOthers: true, connectionStatus: newItemState)
        self.peers.append(newItem)

        let userInfo: [String: Any] = [
          KYNearbyServiceNotificationUserInfoKey.peerID: peerID,
          KYNearbyServiceNotificationUserInfoKey.peerItem: newItem,
        ]
        NotificationCenter.default.post(name: .KYNearbyService.foundPeer, object: nil, userInfo: userInfo)
      }
    }
  }

  // A nearby peer has stopped advertising.
  public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    let peerName = peerID.displayName
    if peerName.isEmpty {
      return
    }

    guard let lostItem = p_getItem(with: peerID) else {
      return
    }

    Task { @MainActor in
      if lostItem.connectionStatus == .connected {
        // Mark it as invisible to rm when disconnected it.
        lostItem.isVisibleToOthers = false
      } else {
        p_removePeerItem(lostItem)
      }
    }
  }

  // Browsing did not start due to an error.
  public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    KYLog(.error, "Browsing did not start due to an error: \(error)")
    let errorMessage = error.localizedDescription
    let userInfo: [String: Any] = [
      KYNearbyServiceNotificationUserInfoKey.errorMessage: errorMessage
    ]
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: .KYNearbyService.browsingError, object: nil, userInfo: userInfo)
    }
  }
}
