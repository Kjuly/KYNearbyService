//
//  KYNearbyServiceConfiguration.swift
//  KYNearbyService
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public class KYNearbyServiceConfiguration {

#if DEBUG
  /// A service type for the demo project (refer to /KYNearbyServiceDemo).
  public static let debug_serviceTypeForDemo: String = "nearby-demo"
#endif

  /// Equeal to info.plist's NSBonjourServices, but w/o the transport protocol.
  public var serviceType: String

  /// Archives folder URL.
  public var archivesFolderURL: URL

  /// Temp folder URL.
  public var tempFolderURL: URL

  /// View interface to present peer invitation view and some error alerts.
  public var viewInterface: KYNearbyServiceViewInterfaceProtocol?

  // MARK: - Init

  public init(
    serviceType: String,
    archivesFolderURL: URL = KYNearbyServiceDefaultFolderURL.archives,
    tempFolderURL: URL = KYNearbyServiceDefaultFolderURL.temp,
    viewInterface: KYNearbyServiceViewInterfaceProtocol? = nil
  ) {
    self.serviceType = serviceType
    self.archivesFolderURL = archivesFolderURL
    self.tempFolderURL = tempFolderURL
    self.viewInterface = viewInterface
  }
}

// MARK: - KYNearbyService View Interface Protocol

@objc
public protocol KYNearbyServiceViewInterfaceProtocol {
#if os(macOS)
  func ky_keyViewControllerForKYNearbyService() -> NSViewController
#else
  func ky_keyViewControllerForKYNearbyService() -> UIViewController
#endif
}

// MARK: - Default Value for "Visible to Others As"

extension KYNearbyServiceConfiguration {

  public static func visibleToOthersAsPlaceholder() -> String {
#if os(macOS)
    return Host.current().localizedName ?? UUID().uuidString
#else
    var name: String = UIDevice.current.name
    if name.isEmpty {
      name = UUID().uuidString
    }
    return name
#endif
  }
}

// MARK: - Default Folder URL

public enum KYNearbyServiceDefaultFolderURL {
  public static let archives: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("archives")
  public static let temp: URL = FileManager.default.temporaryDirectory.appendingPathComponent("tmp")
}

// MARK: - Tests Folder URL

#if DEBUG
public enum KYNearbyServiceTestsFolderURL {
  public static let archives: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("archives_tests")
  public static let temp: URL = FileManager.default.temporaryDirectory.appendingPathComponent("tmp_tests")
}
#endif
