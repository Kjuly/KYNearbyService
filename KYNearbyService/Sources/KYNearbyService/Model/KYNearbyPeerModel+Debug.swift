//
//  KYNearbyPeerModel+Debug.swift
//  KYNearbyService
//
//  Created by Kjuly on 27/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if DEBUG
import MultipeerConnectivity

extension KYNearbyPeerModel {

  static let debug_progress: MockProgress = MockProgress.debug_makeForProcessingPeer()

  @MainActor
  static func debug_makePeer(
    with name: String,
    connectionStatus: KYNearbyPeerConnectionStatus,
    processStatus: KYNearbyPeerProcessStatus = .none,
    processErrorMessage: String? = nil
  ) -> KYNearbyPeerModel {
    let peerID = MCPeerID(displayName: name)
    let item = KYNearbyPeerModel(peerID: peerID, isVisibleToOthers: true, connectionStatus: connectionStatus)

    if processStatus != .none {
      item.processStatus = processStatus
    }

    if let processErrorMessage {
      item.processErrorMessage = processErrorMessage
    }

    return item
  }

  @MainActor
  static func debug_makeProcessingPeer(with name: String, forReceiving: Bool) -> KYNearbyPeerModel {
    let peerID = MCPeerID(displayName: name)
    let item = KYNearbyPeerModel(peerID: peerID, isVisibleToOthers: true, connectionStatus: .connected)

    item.startProcessing(forReceiving: forReceiving)
    item.progress = KYNearbyPeerModel.debug_progress

    return item
  }

  @MainActor
  static func debug_makePeersForAllCases() -> [KYNearbyPeerModel] {
    return [
      .debug_makePeer(with: "User Not Connected", connectionStatus: .notConnected),
      .debug_makePeer(with: "User Connecting", connectionStatus: .connecting),
      // Connected
      .debug_makePeer(with: "User Connected", connectionStatus: .connected),
      .debug_makePeer(with: "User Connected (w/ Data, Pending)", connectionStatus: .connected, processStatus: .pending),
      .debug_makeProcessingPeer(with: "User Connected (w/ Data, Processing)", forReceiving: true),
      .debug_makePeer(
        with: "User Connected (w/ Data, Error)",
        connectionStatus: .connected,
        processStatus: .none,
        processErrorMessage: "Sample Error Message."),
      .debug_makePeer(
        with: "User Connected (w/ Data, Long Error)",
        connectionStatus: .connected,
        processStatus: .none,
        processErrorMessage: "A long long long long long long sample error message."),
      // Declined & Blocked
      .debug_makePeer(with: "User Declined", connectionStatus: .declined),
      .debug_makePeer(with: "User Blocked", connectionStatus: .blocked),
    ]
  }
}

class MockProgress: Progress {

  static func debug_makeForProcessingPeer() -> MockProgress {
    let progress = MockProgress()
    progress.kind = .file
    progress.fileOperationKind = .copying
    progress.totalUnitCount = 102400
    progress.localizedAdditionalDescription = "40 MB of 100 MB"
    return progress
  }

  override var fractionCompleted: Double {
    return 0.4
  }
}

#endif // END #if DEBUG
