//
//  KYNearbyConnectionPeerCell+Actions.swift
//  KYNearbyService
//
//  Created by Kjuly on 28/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI

extension KYNearbyConnectionPeerCell {

  func hasActions(for connectionStatus: KYNearbyPeerConnectionStatus) -> Bool {
    return (connectionStatus != .connecting)
  }

  @ViewBuilder
  func actions(for item: KYNearbyPeerModel) -> some View {
    if item.connectionStatus == .notConnected {
      _newActionOfConnectItem(item)
      _newActionOfBlockItem(item)

    } else if item.connectionStatus == .connected {
      if item.processStatus == .none {
        if self.viewModel.hasSendableData {
          _newActionOfSendResource(for: item)
        }
      } else {
        _newActionOfTerminateProcessingItem(item)
      }
      _newActionOfDisconnectItem(item)

    } else if item.connectionStatus == .declined {
      _newActionOfConnectItem(item)
      _newActionOfBlockItem(item)

    } else if item.connectionStatus == .blocked {
      _newActionOfUnblockItem(item)
    }

    _newActionOfCancel()
  }

  // MARK: - Private

  @ViewBuilder
  func _newActionOfConnectItem(_ item: KYNearbyPeerModel) -> some View {
    Button("LS:Connect".ky_nearbyServiceLocalized) {
      KYNearbyService.shared.invitePeerItem(item)
    }
  }

  @ViewBuilder
  func _newActionOfSendResource(for item: KYNearbyPeerModel) -> some View {
    Button("LS:Send".ky_nearbyServiceLocalized) {
      p_askToSendResource(for: item)
    }
  }

  @ViewBuilder
  func _newActionOfTerminateProcessingItem(_ item: KYNearbyPeerModel) -> some View {
    Button("LS:Terminate".ky_nearbyServiceLocalized, role: .destructive) {
      KYNearbyService.shared.terminateProcessingIfNeededForItem(item)
    }
  }

  @ViewBuilder
  func _newActionOfDisconnectItem(_ item: KYNearbyPeerModel) -> some View {
    Button("LS:Disconnect".ky_nearbyServiceLocalized, role: .destructive) {
      KYNearbyService.shared.terminateProcessingIfNeededForItem(item)
      KYNearbyService.shared.disconnectPeerItem(item)
    }
  }

  // MARK: - Private (Block & Unblock)

  @ViewBuilder
  func _newActionOfBlockItem(_ item: KYNearbyPeerModel) -> some View {
    Button("LS:Block".ky_nearbyServiceLocalized, role: .destructive) {
      KYNearbyService.shared.setPeerItem(item, blocked: true)
    }
  }

  @ViewBuilder
  func _newActionOfUnblockItem(_ item: KYNearbyPeerModel) -> some View {
    Button("LS:Unblock".ky_nearbyServiceLocalized) {
      KYNearbyService.shared.setPeerItem(item, blocked: false)
    }
  }

  // MARK: - Private (Cancel)

  @ViewBuilder
  func _newActionOfCancel() -> some View {
    Button("LS:Cancel".ky_nearbyServiceLocalized, role: .cancel) {
      self.isPresentingActions = false
    }
  }
}
