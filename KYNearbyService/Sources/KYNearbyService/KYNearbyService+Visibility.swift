//
//  KYNearbyService+Visibility.swift
//  KYNearbyService
//
//  Created by Kjuly on 8/2/2022.
//  Copyright © 2022 Kaijie Yu. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import KYLogger

extension KYNearbyService {

  @objc
  public func advertiseSelf(_ shouldAdvertise: Bool) {
    if shouldAdvertise {
      if self.isVisibleToOthers {
        return
      }
      self.isVisibleToOthers = true

      if self.advertiser == nil {
        if let peerID = self.peerID {
          let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: KYNearbyService.config.serviceType)
          advertiser.delegate = self
          self.advertiser = advertiser
        }
      }
      KYLog(.notice, "Start Advertising...")
      self.advertiser?.startAdvertisingPeer()

    } else {
      if !self.isVisibleToOthers {
        return
      }
      self.isVisibleToOthers = false

      KYLog(.notice, "Stop Advertising...")
      self.advertiser?.stopAdvertisingPeer()
      self.advertiser?.delegate = nil
      self.advertiser = nil
    }
  }

  @objc
  public func browseOthers(_ shouldBrowse: Bool) {
    if shouldBrowse {
      if self.isBrowsing {
        return
      }
      self.isBrowsing = true

      if self.browser == nil {
        if let peerID = self.peerID {
          let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: KYNearbyService.config.serviceType)
          browser.delegate = self
          self.browser = browser
        }
      }
      KYLog(.notice, "Browser start browsing for peers...")
      self.browser?.startBrowsingForPeers()

    } else {
      if !self.isBrowsing {
        return
      }
      self.isBrowsing = false

      KYLog(.notice, "Browser stop browsing for peers...")
      self.browser?.stopBrowsingForPeers()
      self.browser?.delegate = nil
      self.browser = nil
    }
  }
}
