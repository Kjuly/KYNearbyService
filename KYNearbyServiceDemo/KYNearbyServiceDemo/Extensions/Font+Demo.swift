//
//  Font+Demo.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI

#if os(macOS)
import AppKit

extension Font {
  static var demo_small: Font { return .system(size: NSFont.smallSystemFontSize) }
  static var demo_smallInBold: Font { return .system(size: NSFont.smallSystemFontSize, weight: .bold) }

  static var demo_label: Font { return .system(size: NSFont.labelFontSize) }
  static var demo_labelInBold: Font { return .system(size: NSFont.labelFontSize, weight: .bold) }
}

#else
import UIKit

extension Font {
  static var demo_small: Font { return .system(size: UIFont.smallSystemFontSize) }
  static var demo_smallInBold: Font { return .system(size: UIFont.smallSystemFontSize, weight: .bold) }

  static var demo_label: Font { return .system(size: UIFont.labelFontSize) }
  static var demo_labelInBold: Font { return .system(size: UIFont.labelFontSize, weight: .bold) }
}
#endif
