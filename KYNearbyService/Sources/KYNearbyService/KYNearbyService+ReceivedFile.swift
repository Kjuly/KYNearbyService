//
//  KYNearbyService+ReceivedFile.swift
//  KYNearbyService
//
//  Created by Kjuly on 31/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import KYLogger

extension KYNearbyService {

  // MARK: - Public (Archives Folder)

  /// Returns a file URL to archive the received file (will append index if a file with the same exits).
  ///
  /// - Parameter filename: The filename of the received file.
  ///
  /// - Returns: A file URL to archive the file.
  ///
  public static func fileURLToArchiveReceivedFile(with filename: String) throws -> URL {
    let folderURL: URL = try reachableFolderURL(KYNearbyService.config.archivesFolderURL)
    return uniqueURL(for: filename, at: folderURL)
  }

  /// Clean all files in the archives folder.
  public static func cleanAllArchives() throws {
    let folderURL: URL = try reachableFolderURL(KYNearbyService.config.archivesFolderURL)
    KYLog(.debug, "Cleaning all files at \(folderURL)...")
    try FileManager.default.removeItem(at: folderURL)
  }

  // MARK: - Public (Temp Folder)

  /// Returns a temp file URL that hosts the received file (will try to remove the duplicated one if it exists).
  ///
  /// - Parameter filename: The filename of the received file.
  ///
  /// - Returns: A temp file URL or throws an error.
  ///
  public static func tempFileURLForReceivedFile(with filename: String) throws -> URL {
    let folderURL: URL = try reachableFolderURL(KYNearbyService.config.tempFolderURL)
    let fileURL: URL = folderURL.appendingPathComponent(filename)

    if FileManager.default.fileExists(atPath: fileURL.path) {
      try FileManager.default.removeItem(at: fileURL)
    }
    return fileURL
  }

  // MARK: - Public (Convenient)

  /// Returns a reachable folder URL (will create the folder with intermediate directories if it doesn't exist).
  ///
  /// - Parameter url: The expected folder URL.
  ///
  /// - Returns: The `url` if it's reachable or the folder has been created succeeded; otherwise, throws an error.
  ///
  public static func reachableFolderURL(_ url: URL) throws -> URL {
    if let isReachable = try? url.checkResourceIsReachable(), isReachable {
      return url
    }

    KYLog(.notice, "Creating \"\(url.lastPathComponent)\" Folder ...")
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    return url
  }

  /// Returns a unique URL for the file under a folder.
  ///
  /// - Parameters
  ///   - filename: The filename of the file.
  ///   - folderURL: The base URL for the folder.
  ///
  /// - Returns: A unique file URL.
  ///
  public static func uniqueURL(for filename: String, at folderURL: URL) -> URL {
    let fileExtension = (filename as NSString).pathExtension
    if fileExtension.isEmpty {
      var url: URL = folderURL.appendingPathComponent(filename)

      var index: Int = 0
      while FileManager.default.fileExists(atPath: url.path) {
        index += 1
        url = folderURL.appendingPathComponent("\(filename) - \(index)")
      }
      return url

    } else {
      var url: URL = folderURL.appendingPathComponent(filename)

      if FileManager.default.fileExists(atPath: url.path) {
        let filenameWithoutExt: String = (filename as NSString).deletingPathExtension
        var index: Int = 0
        repeat {
          index += 1
          url = folderURL.appendingPathComponent("\(filenameWithoutExt) - \(index).\(fileExtension)")
        } while FileManager.default.fileExists(atPath: url.path)
      }
      return url
    }
  }
}
