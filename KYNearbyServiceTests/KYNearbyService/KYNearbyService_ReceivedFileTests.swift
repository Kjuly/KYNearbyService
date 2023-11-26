//
//  KYNearbyService_ReceivedFileTests.swift
//  KYNearbyServiceTests
//
//  Created by Kjuly on 31/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYNearbyService

final class KYNearbyService_ReceivedFileTests: XCTestCase {

  let config = KYNearbyServiceConfiguration(
    serviceType: "test",
    archivesFolderURL: KYNearbyServiceTestsFolderURL.archives,
    tempFolderURL: KYNearbyServiceTestsFolderURL.temp,
    viewInterface: nil
  )

  override func setUpWithError() throws {
    KYNearbyService.setup(with: self.config)
  }

  override func tearDownWithError() throws {
    try? FileManager.default.removeItem(at: self.config.archivesFolderURL)
    try? FileManager.default.removeItem(at: self.config.tempFolderURL)
  }

  // MARK: - Tests for Archives Folder

  //
  // static KYNearbyService.fileURLToArchiveReceivedFile(with:)
  //
  func testFileURLToArchiveReceivedFile() throws {
    let folderURL: URL = try KYNearbyService.reachableFolderURL(self.config.archivesFolderURL)
    defer {
      try? FileManager.default.removeItem(at: folderURL)
    }

    var testURL: URL

    let filename_AAA: String = "AAA.mp4"
    let filename_AAA_1: String = "AAA - 1.mp4"
    let filePath_AAA: String = folderURL.appendingPathComponent(filename_AAA).path
    let filePath_AAA_1: String = folderURL.appendingPathComponent(filename_AAA_1).path

    // File "AAA" doesn't exist, returns "<folderURL>/AAA".
    testURL = try KYNearbyService.fileURLToArchiveReceivedFile(with: filename_AAA)
    XCTAssertEqual(testURL.path, filePath_AAA)

    // File "AAA" exist, returns "<folderURL>/AAA - 1"
    try Data().write(to: URL(fileURLWithPath: filePath_AAA))
    testURL = try KYNearbyService.fileURLToArchiveReceivedFile(with: filename_AAA)
    XCTAssertEqual(testURL.path, filePath_AAA_1)
  }

  //
  // static KYNearbyService.cleanAllArchives()
  //
  func testCleanAllArchives() throws {
    let url: URL = try KYNearbyService.reachableFolderURL(self.config.archivesFolderURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))

    try KYNearbyService.cleanAllArchives()
    XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
  }

  // MARK: - Tests for Temp Folder

  //
  // static KYNearbyService.tempFileURLForReceivedFile(with:)
  //
  func testTempFileURLForReceivedFile() throws {
    let folderURL: URL = try KYNearbyService.reachableFolderURL(self.config.tempFolderURL)
    defer {
      try? FileManager.default.removeItem(at: folderURL)
    }

    var testURL: URL

    let filename_AAA: String = "AAA.mp4"
    let filePath_AAA: String = folderURL.appendingPathComponent(filename_AAA).path

    // File "AAA" doesn't exist, returns "<folderURL>/AAA".
    testURL = try KYNearbyService.tempFileURLForReceivedFile(with: filename_AAA)
    XCTAssertEqual(testURL.path, filePath_AAA)

    // File "AAA" exist, still returns "<folderURL>/AAA" (will remove the existing one first).
    try Data().write(to: URL(fileURLWithPath: filePath_AAA))
    testURL = try KYNearbyService.tempFileURLForReceivedFile(with: filename_AAA)
    XCTAssertEqual(testURL.path, filePath_AAA)
  }

  // MARK: - Tests for Convenient Funcs

  //
  // static KYNearbyService.reachableFolderURL(_:)
  //
  func testReachableFolderURL() throws {
    // Archives Folder
    var url: URL = self.config.archivesFolderURL
    XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))

    url = try KYNearbyService.reachableFolderURL(url)
    XCTAssertEqual(url, self.config.archivesFolderURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))

    // Temp Folder
    url = self.config.tempFolderURL
    XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))

    url = try KYNearbyService.reachableFolderURL(url)
    XCTAssertEqual(url, self.config.tempFolderURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
  }

  //
  // static KYNearbyService.uniqueURL(for:at:)
  //
  func testUniqueURLForFilenameAtFolder() throws { // swiftlint:disable:this function_body_length
    let folderURL: URL = try KYNearbyService.reachableFolderURL(self.config.archivesFolderURL)
    defer {
      try? FileManager.default.removeItem(at: folderURL)
    }

    var testURL: URL

    //
    // Filename w/o extension
    //
    var filename_AAA: String = "AAA"
    var filename_AAA_1: String = "AAA - 1"
    var filename_AAA_2: String = "AAA - 2"
    var filePath_AAA: String = folderURL.appendingPathComponent(filename_AAA).path
    var filePath_AAA_1: String = folderURL.appendingPathComponent(filename_AAA_1).path
    var filePath_AAA_2: String = folderURL.appendingPathComponent(filename_AAA_2).path

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), false)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), false)

    // Create file: "AAA"
    try Data().write(to: URL(fileURLWithPath: filePath_AAA))
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), true)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA_1)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), true)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA_1), false)

    // Create file: "AAA - 1"
    try Data().write(to: URL(fileURLWithPath: filePath_AAA_1))
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), true)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA_1), true)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA_2)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA_1, at: folderURL)
    XCTAssertEqual(testURL.path, folderURL.appendingPathComponent("/\(filename_AAA_1) - 1").path)

    //
    // Filename w/ extension
    //
    filename_AAA = "AAA.mp4"
    filename_AAA_1 = "AAA - 1.mp4"
    filename_AAA_2 = "AAA - 2.mp4"
    filePath_AAA = folderURL.appendingPathComponent(filename_AAA).path
    filePath_AAA_1 = folderURL.appendingPathComponent(filename_AAA_1).path
    filePath_AAA_2 = folderURL.appendingPathComponent(filename_AAA_2).path

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), false)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), false)

    // Create file: "AAA.mp4"
    try Data().write(to: URL(fileURLWithPath: filePath_AAA))
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), true)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA_1)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), true)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA_1), false)

    // Create file: "AAA - 1.mp4"
    try Data().write(to: URL(fileURLWithPath: filePath_AAA_1))
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA), true)
    XCTAssertEqual(FileManager.default.fileExists(atPath: filePath_AAA_1), true)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA, at: folderURL)
    XCTAssertEqual(testURL.path, filePath_AAA_2)

    testURL = KYNearbyService.uniqueURL(for: filename_AAA_1, at: folderURL)
    XCTAssertEqual(testURL.path, folderURL.appendingPathComponent("AAA - 1 - 1.mp4").path)
  }
}
