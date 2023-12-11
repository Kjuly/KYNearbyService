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
    // static let small: CGFloat = 2
    static let regular: CGFloat = 5
    // static let large: CGFloat = 10
  }

  public enum IconButtonSideLength {
    static let regular: CGFloat = 44
    static let small: CGFloat = 32
  }

  public enum PeerCell {
    public static let horizontalSpacing: CGFloat = 10
    public static let peerStatusIndicatorSideLength: CGFloat = 20
    public static let secondaryContentLeadingPadding: CGFloat = peerStatusIndicatorSideLength + horizontalSpacing
  }
}
