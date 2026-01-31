//
//  KYNearbyServiceLocalizations.swift
//  KYNearbyService
//
//  Created by Kjuly on 24/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

extension String {

  public var ky_nearbyServiceLocalized: String {
#if KY_NEARBY_SERVICE_FRAMEWORK
    NSLocalizedString(
      self,
      tableName: "KYNearbyServiceLocalizations",
      bundle: Bundle(identifier: "com.kjuly.KYNearbyService") ?? Bundle.main,
      value: "",
      comment: ""
    )
#else
    NSLocalizedString(self, tableName: "KYNearbyServiceLocalizations", bundle: .module, value: "", comment: "")
#endif // KY_NEARBY_SERVICE_FRAMEWORK
  }
}
