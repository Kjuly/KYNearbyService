//
//  KYNearbyService+Internal.swift
//  KYNearbyService
//
//  Created by Kjuly on 13/11/2020.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import MultipeerConnectivity

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension KYNearbyService {

  func p_getItem(with peerID: MCPeerID) -> KYNearbyPeerModel? {
    return self.peers.first { $0.matchesWithPeerID(peerID) }
  }

  func p_removePeerItem(_ item: KYNearbyPeerModel) {
    if let index = self.peers.firstIndex(where: { $0.matchesWithPeerID(item.peerID) }) {
      self.peers.remove(at: index)
    }

    let userInfo: [String: Any] = [
      KYNearbyServiceNotificationUserInfoKey.peerID: item.peerID,
      KYNearbyServiceNotificationUserInfoKey.peerItem: item,
    ]
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: .KYNearbyService.lostPeer, object: nil, userInfo: userInfo)
    }
  }

  func p_popResourceActionInfo(with filename: String) -> [String: Any]? {
    return self.receivedResourceActionInfo.removeValue(forKey: filename)
  }

#if os(macOS)
  func p_appKeyViewController() -> NSViewController? {
    if let viewInterface = KYNearbyService.config.viewInterface {
      return viewInterface.ky_keyViewControllerForKYNearbyService()
    } else {
      return NSApplication.shared.keyWindow?.contentViewController
    }
  }
#else
  func p_appKeyViewController() -> UIViewController? {
    if let viewInterface = KYNearbyService.config.viewInterface {
      return viewInterface.ky_keyViewControllerForKYNearbyService()
    } else {
      let keyWindow: UIWindow? = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .filter { $0.activationState == .foregroundActive }
        .first?.keyWindow
      return keyWindow?.rootViewController
    }
  }
#endif
}
