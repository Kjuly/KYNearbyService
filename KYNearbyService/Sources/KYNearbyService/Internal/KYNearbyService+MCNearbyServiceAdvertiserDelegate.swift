//
//  KYNearbyService+MCNearbyServiceAdvertiserDelegate.swift
//  KYNearbyService
//
//  Created by Kjuly on 8/2/2022.
//  Copyright © 2022 Kaijie Yu. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import KYLogger

#if os(macOS)
import AppKit
#else
import UIKit
#endif // os(macOS)

extension KYNearbyService: MCNearbyServiceAdvertiserDelegate {

  /// Incoming invitation request. Call the invitationHandler block with YES
  ///   and a valid session to connect the inviting peer to the session.
  public func advertiser(
    _ advertiser: MCNearbyServiceAdvertiser,
    didReceiveInvitationFromPeer peerID: MCPeerID,
    withContext context: Data?,
    invitationHandler: @escaping (Bool, MCSession?) -> Void
  ) {
    if self.blockedPeerIDs.contains(peerID) {
      KYLog(.warn, "Ignore a blocked peer: \(peerID) (\"\(peerID.displayName)\")")
      return
    }

    let title: String = "LS:Invitation".ky_nearbyServiceLocalized
    let message: String = String(format: "LS:%@ wants to connect.".ky_nearbyServiceLocalized, peerID.displayName)

    nonisolated(unsafe) let unsafeInvitationHandler = invitationHandler

    Task { @MainActor in
      let accepted: Bool = await _presentInvitationDialog(
        title: title,
        message: message,
        peerID: peerID
      )
      unsafeInvitationHandler(accepted, self.session)
    }
  }

  /// Advertising did not start due to an error.
  public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    Task { @MainActor in
      KYNearbyService.presentErrorAlert(message: error.localizedDescription)
    }
  }
}

// MARK: - Private - Invitation Dialog
@MainActor
extension KYNearbyService {

  private func _blockInvitation(from peerID: MCPeerID) {
    self.blockedPeerIDs.insert(peerID)

    if let matchedItem = self.p_getItem(with: peerID) {
      matchedItem.connectionStatus = .blocked
      NotificationCenter.default.post(name: .KYNearbyService.peerDidChangeState, object: matchedItem)
    }
  }

  private func _acceptInvitation(from peerID: MCPeerID) {
    // If the connection accepted peer not visible to others, show it in this connected device.
    if self.p_getItem(with: peerID) == nil {
      let newItem = KYNearbyPeerModel(peerID: peerID, isVisibleToOthers: false, connectionStatus: .connected)
      self.peers.append(newItem)

      let userInfo: [String: Any] = [
        KYNearbyServiceNotificationUserInfoKey.peerID: peerID,
        KYNearbyServiceNotificationUserInfoKey.peerItem: newItem,
      ]
      NotificationCenter.default.post(name: .KYNearbyService.foundPeer, object: nil, userInfo: userInfo)
    }
  }

  private func _presentInvitationDialog(
    title: String,
    message: String,
    peerID: MCPeerID
  ) async -> Bool {

    await withCheckedContinuation { continuation in
#if os(macOS)
      let alert = NSAlert()
      alert.messageText = title
      alert.informativeText = message
      alert.addButton(withTitle: "LS:Accept".ky_nearbyServiceLocalized).keyEquivalent = "\r"
      alert.addButton(withTitle: "LS:Block".ky_nearbyServiceLocalized).keyEquivalent = "b"
      alert.addButton(withTitle: "LS:Decline".ky_nearbyServiceLocalized).keyEquivalent = "d"
      alert.buttons[1].hasDestructiveAction = true
      let alertResponse: NSApplication.ModalResponse = alert.runModal()
      switch alertResponse {
        // Accept
      case .alertFirstButtonReturn:
        _acceptInvitation(from: peerID)
        continuation.resume(returning: true)
        // Block
      case .alertSecondButtonReturn:
        _blockInvitation(from: peerID)
        continuation.resume(returning: false)
        // Decline
      default:
        continuation.resume(returning: false)
      }
#else
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertController.addAction(.init(title: "LS:Decline".ky_nearbyServiceLocalized, style: .cancel, handler: { _ in
        continuation.resume(returning: false)
      }))
      alertController.addAction(.init(title: "LS:Block".ky_nearbyServiceLocalized, style: .destructive, handler: { _ in
        self._blockInvitation(from: peerID)
        continuation.resume(returning: false)
      }))
      alertController.addAction(.init(title: "LS:Accept".ky_nearbyServiceLocalized, style: .default, handler: { _ in
        self._acceptInvitation(from: peerID)
        continuation.resume(returning: true)
      }))
      KYNearbyService.p_appKeyViewController()?.present(alertController, animated: true)
#endif // os(macOS)
    }
  }
}
