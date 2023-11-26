//
//  KYNearbyServiceLocalizations.swift
//  KYNearbyService
//
//  Created by Kjuly on 24/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if KY_NEARBY_SERVICE_FRAMEWORK

extension String {
  public var ky_nearbyServiceLocalized: String {
    return NSLocalizedString(self,
                             tableName: "KYNearbyServiceLocalizations",
                             bundle: Bundle(identifier: "com.kjuly.KYNearbyService") ?? Bundle.main,
                             value: "",
                             comment: "")
  }
}

extension NSString {
  @objc public var ky_nearbyServiceLocalized: NSString {
    return NSLocalizedString(self as String,
                             tableName: "KYNearbyServiceLocalizations",
                             bundle: Bundle(identifier: "com.kjuly.KYNearbyService") ?? Bundle.main,
                             value: "",
                             comment: "") as NSString
  }
}

#else

extension String {
  public var ky_nearbyServiceLocalized: String {
    return NSLocalizedString(self, tableName: "KYNearbyServiceLocalizations", bundle: .module, value: "", comment: "")
  }
}

extension NSString {
  @objc public var ky_nearbyServiceLocalized: NSString {
    return NSLocalizedString(self as String, tableName: "KYNearbyServiceLocalizations", bundle: .module, value: "", comment: "") as NSString
  }
}

#endif
