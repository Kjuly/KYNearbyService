//
//  KYNearbyPeerModel+ObjC.swift
//  KYNearbyService
//
//  Created by Kjuly on 12/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

@objc
extension KYNearbyPeerModel {

  public static let kKYNearbyPeerModelPropertyOfProgressCounter = "progressCounter"

  // MARK: - Connection Status

  public func hasNotConnected() -> Bool {
    return self.connectionStatus == .notConnected
  }

  public func isConnecting() -> Bool {
    return self.connectionStatus == .connecting
  }

  public func isConnected() -> Bool {
    return self.connectionStatus == .connected
  }

  // public func isDeclined() -> Bool { return self.connectionStatus == .declined }

  public func isBlocked() -> Bool {
    return self.connectionStatus == .blocked
  }
}
