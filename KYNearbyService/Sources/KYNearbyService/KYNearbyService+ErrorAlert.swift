//
//  KYNearbyService+Alert.swift
//  KYNearbyService
//
//  Created by Kjuly on 25/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif // os(macOS)

extension KYNearbyService {

  /// Present an error alert, no matter KYNearbyConnectionView has not been presented or not.
  ///
  /// - Parameter message: Error details.
  ///
  @MainActor
  static func presentErrorAlert(message: String) {
#if os(macOS)
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = "LS:Error Occurred".ky_nearbyServiceLocalized
    alert.informativeText = message
    alert.addButton(withTitle: "LS:Cancel".ky_nearbyServiceLocalized)
    alert.runModal()
#else
    let alertController = UIAlertController(title: "LS:Error Occurred".ky_nearbyServiceLocalized, message: message, preferredStyle: .alert)
    alertController.addAction(.init(title: "LS:Cancel".ky_nearbyServiceLocalized, style: .cancel))
    p_appKeyViewController()?.present(alertController, animated: true)
#endif // os(macOS)
  }
}
