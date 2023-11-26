//
//  View+Demo.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI

struct HideScrollContentBackgroundModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 16.0, *) {
      content.scrollContentBackground(.hidden)
    } else {
      content
    }
  }
}

extension View {
  func demo_nearbyServiceDemoHideScrollContentBackground() -> some View {
    modifier(HideScrollContentBackgroundModifier())
  }
}
