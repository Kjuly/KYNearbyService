//
//  Color+Demo.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Color {

  // MARK: - Background Color

#if os(macOS)
  static var demo_defaultBackground: Color { return Color(nsColor: .controlBackgroundColor) }
  static var demo_secondaryBackground: Color { return Color(nsColor: .textBackgroundColor) }
#else
  static var demo_defaultBackground: Color { return Color(uiColor: .systemGroupedBackground) }
  static var demo_secondaryBackground: Color { return Color(uiColor: .secondarySystemGroupedBackground) }
#endif

  // MARK: - Accent Color

  static var demo_accent: Color { return .orange }

  // MARK: - Foreground/Content Color

  static var demo_defaultContent: Color { return .primary }
  static var demo_secondaryContent: Color { return .secondary }

  // MARK: - Status Color

  static var demo_greenStatus: Color { return .green }
  static var demo_redStatus: Color { return .red }

  static var demo_disabledStatus: Color { return .secondary }
}
