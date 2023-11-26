//
//  KYNearbyConnectionViewModel+Notification.swift
//  KYNearbyService
//
//  Created by Kjuly on 26/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import KYLogger

extension KYNearbyConnectionViewModel {

  func notification_setup() {
    let defaultCenter = NotificationCenter.default
    //
    // From KYNearbyService
    //
    defaultCenter.addObserver(
      self,
      selector: #selector(_handleKYNearbyServicePeerDidChangeStateNotification),
      name: .KYNearbyService.peerDidChangeState,
      object: nil)
    defaultCenter.addObserver(
      self,
      selector: #selector(_handleKYNearbyServiceFoundPeerNotification),
      name: .KYNearbyService.foundPeer,
      object: nil)
    defaultCenter.addObserver(
      self,
      selector: #selector(_handleKYNearbyServiceLostPeerNotification),
      name: .KYNearbyService.lostPeer,
      object: nil)

    defaultCenter.addObserver(
      self,
      selector: #selector(_handleKYNearbyServiceBrowsingErrorNotification),
      name: .KYNearbyService.browsingError,
      object: nil)
  }

  // MARK: - Private

  @MainActor
  private func _updateWithLastestPeers() {
    self.peers = KYNearbyService.shared.peers
    self.peersCount = self.peers.count

    let isDisconnectionEnabled: Bool = (self.peersCount == 0 ? false : KYNearbyService.shared.hasPeerConnected())
    if self.isDisconnectionEnabled != isDisconnectionEnabled {
      self.isDisconnectionEnabled = isDisconnectionEnabled
    }
  }

  // MARK: - Private (KYNearbyService Notification Handler)

  @MainActor
  @objc private func _handleKYNearbyServicePeerDidChangeStateNotification(_ note: Notification) {
    KYLog(.notice, "KYNearbyService: Peer Did Change State")
    _updateWithLastestPeers()
  }

  @MainActor
  @objc private func _handleKYNearbyServiceFoundPeerNotification(_ note: Notification) {
    KYLog(.notice, "KYNearbyService: Peer Found")
    _updateWithLastestPeers()
    /*if
      let userInfo = note.userInfo,
      let peerItem = userInfo[KYNearbyServiceNotificationUserInfoKey.peerItem] as? KYNearbyPeerModel
    {
      _didFoundPeerItem(peerItem)
    }*/
  }

  @MainActor
  @objc private func _handleKYNearbyServiceLostPeerNotification(_ note: Notification) {
    KYLog(.notice, "KYNearbyService: Peer Lost")
    _updateWithLastestPeers()
    /*if
      let userInfo = note.userInfo,
      let peerItem = userInfo[KYNearbyServiceNotificationUserInfoKey.peerItem] as? KYNearbyPeerModel
    {
      _didLostPeerItem(peerItem)
    }*/
  }

  @MainActor
  @objc private func _handleKYNearbyServiceBrowsingErrorNotification(_ note: Notification) {
    guard
      let userInfo = note.userInfo,
      let errorMessage = userInfo[KYNearbyServiceNotificationUserInfoKey.errorMessage] as? String
    else {
      return
    }
    KYLog(.error, "KYNearbyService: Browsing Error: \(errorMessage)")
    KYNearbyService.shared.presentErrorAlert(message: errorMessage)
  }
}
