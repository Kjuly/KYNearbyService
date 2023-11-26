//
//  KYNearbyConnectionViewTheme.swift
//  KYNearbyService
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI

public struct KYNearbyConnectionViewTheme {

  // MARK: - Font

  var labelFont: Font
  var labelFontInBold: Font

  var smallFont: Font
  var smallFontInBold: Font

  // MARK: - Color

  var accentColor: Color

  var defaultContentColor: Color
  var secondaryContentColor: Color

  var defaultBackgroundColor: Color
  var secondaryBackgroundColor: Color

  var greenStatusColor: Color
  var redStatusColor: Color

  var disabledStatusColor: Color

  // MARK: - Init

  public init(
    labelFont: Font,
    labelFontInBold: Font,
    smallFont: Font,
    smallFontInBold: Font,
    accentColor: Color,
    defaultContentColor: Color,
    secondaryContentColor: Color,
    defaultBackgroundColor: Color,
    secondaryBackgroundColor: Color,
    greenStatusColor: Color,
    redStatusColor: Color,
    disabledStatusColor: Color
  ) {
    self.labelFont = labelFont
    self.labelFontInBold = labelFontInBold
    self.smallFont = smallFont
    self.smallFontInBold = smallFontInBold
    self.accentColor = accentColor
    self.defaultContentColor = defaultContentColor
    self.secondaryContentColor = secondaryContentColor
    self.defaultBackgroundColor = defaultBackgroundColor
    self.secondaryBackgroundColor = secondaryBackgroundColor
    self.greenStatusColor = greenStatusColor
    self.redStatusColor = redStatusColor
    self.disabledStatusColor = disabledStatusColor
  }

  public static func makeDefault() -> KYNearbyConnectionViewTheme {
#if os(macOS)
    return .init(
      labelFont: .system(size: NSFont.labelFontSize),
      labelFontInBold: .system(size: NSFont.labelFontSize, weight: .bold),
      smallFont: .system(size: NSFont.smallSystemFontSize),
      smallFontInBold: .system(size: NSFont.smallSystemFontSize, weight: .bold),
      accentColor: .blue,
      defaultContentColor: .primary,
      secondaryContentColor: .secondary,
      defaultBackgroundColor: .init(nsColor: .windowBackgroundColor),
      secondaryBackgroundColor: .init(nsColor: .windowBackgroundColor),
      greenStatusColor: .green,
      redStatusColor: .red,
      disabledStatusColor: .secondary)
#else
    return .init(
      labelFont: .system(size: UIFont.labelFontSize),
      labelFontInBold: .system(size: UIFont.labelFontSize, weight: .bold),
      smallFont: .system(size: UIFont.smallSystemFontSize),
      smallFontInBold: .system(size: UIFont.smallSystemFontSize, weight: .bold),
      accentColor: .blue,
      defaultContentColor: .primary,
      secondaryContentColor: .secondary,
      defaultBackgroundColor: .init(uiColor: .systemGroupedBackground),
      secondaryBackgroundColor: .init(uiColor: .secondarySystemGroupedBackground),
      greenStatusColor: .green,
      redStatusColor: .red,
      disabledStatusColor: .secondary)
#endif
  }
}
