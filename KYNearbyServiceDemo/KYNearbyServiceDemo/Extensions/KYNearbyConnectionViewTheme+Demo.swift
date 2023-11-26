//
//  KYNearbyConnectionViewTheme+Demo.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import KYNearbyService

extension KYNearbyConnectionViewTheme {

  static func demo_makeTheme() -> KYNearbyConnectionViewTheme {
    return .init(
      labelFont: .demo_label,
      labelFontInBold: .demo_labelInBold,
      smallFont: .demo_small,
      smallFontInBold: .demo_smallInBold,
      accentColor: .demo_accent,
      defaultContentColor: .demo_defaultContent,
      secondaryContentColor: .demo_secondaryContent,
      defaultBackgroundColor: .demo_defaultBackground,
      secondaryBackgroundColor: .demo_secondaryBackground,
      greenStatusColor: .demo_greenStatus,
      redStatusColor: .demo_redStatus,
      disabledStatusColor: .demo_disabledStatus)
  }
}
