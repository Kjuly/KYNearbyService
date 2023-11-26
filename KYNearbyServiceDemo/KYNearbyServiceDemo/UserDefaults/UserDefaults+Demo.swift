//
//  UserDefaults+Demo.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

extension UserDefaults {

  private static let customDisplayNameKey_: String = "custom_display_name"

  static func demo_nearbyServiceCustomDisplayName() -> String? {
    return standard.string(forKey: customDisplayNameKey_)
  }

  static func demo_setNearbyServiceCustomDisplayName(_ name: String?) {
    standard.set(name, forKey: customDisplayNameKey_)
  }
}
