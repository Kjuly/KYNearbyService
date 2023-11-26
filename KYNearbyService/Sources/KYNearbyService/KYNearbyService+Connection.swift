//
//  KYNearbyService+Connection.swift
//  KYNearbyService
//
//  Created by Kjuly on 8/2/2022.
//  Copyright © 2022 Kaijie Yu. All rights reserved.
//

import Foundation

extension KYNearbyService {

  @MainActor
  @objc
  public func setPeerItem(_ item: KYNearbyPeerModel, blocked: Bool) {
    var updated: Bool = false

    if blocked {
      if item.connectionStatus != .blocked {
        item.connectionStatus = .blocked
        updated = true
      }
      self.blockedPeerIDs.insert(item.peerID)

    } else {
      if item.connectionStatus == .blocked {
        item.connectionStatus = .notConnected
        updated = true
      }
      self.blockedPeerIDs.remove(item.peerID)
    }

    if updated {
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: .KYNearbyService.peerDidChangeState, object: item)
      }
    }
  }

  @MainActor
  @objc
  public func invitePeerItem(_ item: KYNearbyPeerModel) {
    item.connectionStatus = .connecting

    if let session = self.session {
      self.browser?.invitePeer(item.peerID, to: session, withContext: nil, timeout: 0)
    }
  }

  /*
  - (void)connectPeerItem:(KYNearbyPeerModel *)item
  {
    item.state = .connecting

    typeof(self) __weak weakSelf = self
    [self.session nearbyConnectionDataForPeer:item.peerID withCompletionHandler:^(NSData * _Nullable connectionData, NSError * _Nullable error) {
      if (error) {
        KYLogError(@"Failed to Connect to Peer: %@, ERROR: %@", item.peerID.displayName, [error localizedDescription])
      } else {
        [weakSelf.session connectPeer:item.peerID withNearbyConnectionData:connectionData]
      }
    }]
  }*/

  @MainActor
  @objc
  public func hasPeerConnected() -> Bool {
    return self.peers.contains { $0.connectionStatus == .connected }
  }

  /*
  public func countOfConnectedPeers() -> Int {
    return self.session?.connectedPeers.count // Note it will not count the connecting peer.
  }*/

  @objc
  public func terminateProcessingIfNeededForItem(_ item: KYNearbyPeerModel) {
    if item.processStatus != .none {
      item.processStatus = .none // Mark it immeditely to avoid duplicate calling.
      item.progress?.cancel()
    }
  }

  @objc
  public func disconnectPeerItem(_ item: KYNearbyPeerModel) {
    self.session?.cancelConnectPeer(item.peerID)
  }

  @objc
  public func disconnectAllPeers() {
    self.session?.disconnect()
  }
}
