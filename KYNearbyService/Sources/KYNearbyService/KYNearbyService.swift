//
//  KYNearbyService.swift
//  KYNearbyService
//
//  Created by Kjuly on 13/11/2020.
//  Copyright © 2020 Kjuly. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import KYLogger

@objc
public class KYNearbyService: NSObject {

  /// The configuration for the nearby service.
  static var config = KYNearbyServiceConfiguration(serviceType: "")

  /// Max allowable peer name length in Byte.
  private static let maxAllowablePeerNameLengthInByte: Int = 63

  /// KYNearbyService singleton.
  @objc public static let shared = KYNearbyService()

  public private(set) var peerID: MCPeerID?
  public private(set) var session: MCSession?

  @objc public internal(set) var isVisibleToOthers: Bool = false

  var isBrowsing: Bool = false

  var advertiser: MCNearbyServiceAdvertiser?
  var browser: MCNearbyServiceBrowser?

  @objc public internal(set) var peers: [KYNearbyPeerModel] = []
  var blockedPeerIDs: Set<MCPeerID> = []

  /// Received resource actions to handle manually if needed.
  ///
  /// Will just save the received resource to "archives" folder if none set.
  ///
  /// The Dictionary Structure:
  /// ```json
  /// {
  ///   "<resource_filename>": {
  ///     "action": <custom_action_enum_or_options_raw_value> (Int),
  ///     "asset_id": <id> (Int64)
  ///     "media_id": <id> (Int64, Optional)
  ///   }
  /// }
  /// ```
  var receivedResourceActionInfo: [String: [String: Any]] = [:]

  // MARK: - Deinit

  deinit {
    self.session?.delegate = nil
    self.advertiser?.delegate = nil
    self.browser?.delegate = nil
  }

  // MARK: - Init

  public static func setup(with config: KYNearbyServiceConfiguration) {
    KYNearbyService.config = config
  }

  private override init() {
    if KYNearbyService.config.serviceType.isEmpty {
      let errorMessage = "Service Type is required before accessing KYNearbyService.shared. Please use KYNearbyService.setup(with:) to setup first."
      KYLog(.critical, errorMessage)
#if DEBUG
      if NSClassFromString("XCTest") == nil && ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil {
        fatalError(errorMessage)
      } else {
        KYNearbyService.config = KYNearbyServiceConfiguration(serviceType: KYNearbyServiceConfiguration.debug_serviceTypeForDemo)
      }
#endif
    }
    super.init()
  }

  // MARK: - Public

  @objc
  public func setupSession(with displayName: String) {
    var adjustedDisplayName: String = (displayName.isEmpty ? KYNearbyServiceConfiguration.visibleToOthersAsPlaceholder() : displayName)

    if adjustedDisplayName.lengthOfBytes(using: .utf8) > KYNearbyService.maxAllowablePeerNameLengthInByte {
      var trimmedName: String?
      if let bytes = (adjustedDisplayName as NSString).utf8String {
        trimmedName = NSString(
          bytes: bytes,
          length: KYNearbyService.maxAllowablePeerNameLengthInByte,
          encoding: NSUTF8StringEncoding) as? String
      }
      adjustedDisplayName = trimmedName ?? UUID().uuidString
    }

    if self.session != nil {
      if self.session?.myPeerID.displayName == adjustedDisplayName {
        KYLog(.warn, "Do Nothing (Same displayName: \(adjustedDisplayName)")
        return
      }

      if self.isVisibleToOthers {
        advertiseSelf(false)
      }
      releaseResouceIfNeeded()

      self.session?.disconnect()
      self.session?.delegate = nil
      self.session = nil
      self.peerID = nil
    }

    KYLog(.notice, "New Session w/ displayName: \(adjustedDisplayName)")
    let peerID = MCPeerID(displayName: adjustedDisplayName)
    self.peerID = peerID

    // TODO: ISSUE#20220504: Use MCEncryptionRequired ?
    let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
    session.delegate = self
    self.session = session
  }

  public func releaseResouceIfNeeded() {
    if !self.peers.isEmpty {
      self.peers.removeAll()
    }
  }
}
