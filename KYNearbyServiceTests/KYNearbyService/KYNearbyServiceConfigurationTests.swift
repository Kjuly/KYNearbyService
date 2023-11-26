//
//  KYNearbyServiceConfigurationTests.swift
//  KYNearbyServiceTests
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYNearbyService

final class KYNearbyServiceConfigurationTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  //
  // enum KYNearbyServiceDefaultFolderURL
  //
  func testKYNearbyServiceDefaultFolderURL() throws {
    XCTAssertEqual(KYNearbyServiceDefaultFolderURL.archives,
                   FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("archives"))
    XCTAssertEqual(KYNearbyServiceDefaultFolderURL.temp,
                   FileManager.default.temporaryDirectory.appendingPathComponent("tmp"))
  }
}
