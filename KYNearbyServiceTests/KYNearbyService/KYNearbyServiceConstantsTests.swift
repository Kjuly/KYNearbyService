//
//  KYNearbyServiceConstantsTests.swift
//  KYNearbyServiceTests
//
//  Created by Kjuly on 11/1/2021.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYNearbyService

final class KYNearbyServiceConstantsTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  //
  // enum KYNearbyServiceNotificationUserInfoKey
  //
  func testKYNearbyServiceNotificationUserInfoKey() throws {
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKey.peerID, "peer_id")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKey.peerItem, "peer_item")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKey.state, "state")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKey.filename, "filename")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKey.url, "url")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKey.extraActionInfo, "extra_action_info")
    XCTAssertEqual(KYNearbyServiceNotificationUserInfoKey.errorMessage, "error_msg")
  }

  //
  // enum KYNearbyPeerConnectionStatus
  //
  func testKYNearbyPeerConnectionStatus() throws {
    XCTAssertEqual(KYNearbyPeerConnectionStatus.notConnected.text, "Not Connected")
    XCTAssertEqual(KYNearbyPeerConnectionStatus.connecting.text, "Connecting")
    XCTAssertEqual(KYNearbyPeerConnectionStatus.connected.text, "Connected")
    XCTAssertEqual(KYNearbyPeerConnectionStatus.declined.text, "Declined")
    XCTAssertEqual(KYNearbyPeerConnectionStatus.blocked.text, "Blocked")
  }
}
