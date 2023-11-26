//
//  KYNearbyConnectionViewConstants.swift
//  KYNearbyService
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

enum KYNearbyConnectionViewIconName {
  static let peerStatusIndicator: String = "circle.fill"
  static let terminateProcessing: String = "stop.circle"
}

enum KYNearbyConnectionViewDimension {

  enum Margin {
    static let level_1: CGFloat = 5
    static let level_2: CGFloat = 10
  }

  public enum ViewCornerRadius {
    // public static let small: CGFloat =  2
    public static let regular: CGFloat =  5
    // public static let large: CGFloat = 10
  }

  public enum IconButtonSizeLength {
    public static let regular: CGFloat = 44
    public static let small: CGFloat = 32
  }
}
