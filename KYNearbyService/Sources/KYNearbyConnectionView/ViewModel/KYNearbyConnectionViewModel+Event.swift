//
//  KYNearbyConnectionViewModel+Event.swift
//  KYNearbyService
//
//  Created by Kjuly on 28/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

extension KYNearbyConnectionViewModel {

  func didEndEditingVisibleToOthersAs(_ text: String?) {
    if text == self.originalVisibleToOthersAsText {
      return
    }

    let latestName: String = text ?? ""
    self.originalVisibleToOthersAsText = latestName
    self.visibleToOthersAsText = latestName
    NotificationCenter.default.post(name: .KYNearbyService.didUpdatePeerDisplayName, object: latestName)

    // Renew session if the name is different.
    let peerDisplayName = (latestName.isEmpty ? self.visibleToOthersAsPlaceholder : latestName)
    let nearbyService = KYNearbyService.shared
    if nearbyService.peerID?.displayName == peerDisplayName {
      return
    }

    let wasVisibleToOthers = nearbyService.isVisibleToOthers
    nearbyService.setupSession(with: peerDisplayName)

    if wasVisibleToOthers {
      nearbyService.advertiseSelf(true)
    }
  }

  func didChangeVisibleToOthersSwitch(_ on: Bool) {
    KYNearbyService.shared.advertiseSelf(on)
  }

  func didPressDisconnectAllButton() {
    KYNearbyService.shared.disconnectAllPeers()
  }
}
