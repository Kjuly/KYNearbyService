//
//  View+KYNearbyConnectionView.swift
//  KYNearbyService
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI

struct HideScrollContentBackgroundModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 16.0, macOS 13.0, *) {
      content.scrollContentBackground(.hidden)
    } else {
      content
    }
  }
}

extension View {
  func ky_nearbyConnectionViewHideScrollContentBackground() -> some View {
    modifier(HideScrollContentBackgroundModifier())
  }
}
