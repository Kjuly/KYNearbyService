//
//  KYNearbyServiceConstants_ObjCTests.swift
//  KYNearbyServiceTests
//
//  Created by Kjuly on 12/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYNearbyService

final class KYNearbyServiceConstants_ObjCTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  //
  // KYNearbyServiceNotificationUserInfoKeyObjC
  //
  func testKYNearbyServiceNotificationUserInfoKeyObjC() throws {
    // XCTAssertEqual(KYNearbyServiceNotificationUserInfoKeyObjC.peerID, "peer_id")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKeyObjC.peerItem, "peer_item")
    // XCTAssertEqual(KYNearbyServiceNotificationUserInfoKeyObjC.state, "state")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKeyObjC.filename, "filename")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKeyObjC.url, "url")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKeyObjC.extraActionInfo, "extra_action_info")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKeyObjC.errorMessage, "error_msg")
  }
}
