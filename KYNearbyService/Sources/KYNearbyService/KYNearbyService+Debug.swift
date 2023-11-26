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

  @MainActor
  public func debug_populateMockPeers() {
    self.peers = KYNearbyPeerModel.debug_makePeersForAllCases()
  }
}
#endif
