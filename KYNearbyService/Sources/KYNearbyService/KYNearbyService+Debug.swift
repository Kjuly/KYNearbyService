//
//  KYNearbyService+Debug.swift
//  KYNearbyService
//
//  Created by Kjuly on 28/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if DEBUG
extension KYNearbyService {

  public enum DebugPreviewScenario: Int {
    case none = 0
    /// Preview all peer statuses.
    case allPeerStatuses
    /// Preview a peer that's sending a resource.
    case sendingResource
    /// Preview a peer that's receiving a resource.
    case receivingResource
  }

  /// Populate mock peers for preview.
  @MainActor
  public func debug_populateMockPeers(for scenario: DebugPreviewScenario) {
    switch scenario {
    case .allPeerStatuses:
      self.peers = KYNearbyPeerModel.debug_makePeersForAllCases()
    case .sendingResource:
      self.peers = [KYNearbyPeerModel.debug_makeProcessingPeer(with: "Macbook Pro", forReceiving: false)]
    case .receivingResource:
      self.peers = [KYNearbyPeerModel.debug_makeProcessingPeer(with: "iPhone 15 Pro Max", forReceiving: true)]
    default:
      break
    }
  }
}
#endif
