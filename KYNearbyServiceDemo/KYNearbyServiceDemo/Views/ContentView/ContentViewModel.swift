//
//  ContentViewModel.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 28/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI
import KYNearbyService

class ContentViewModel: ObservableObject {

  @Published var selectedFilename: String?
  @Published var error: ContentViewModelError?

  deinit {
    notification_removeObserver()
  }

  init() {
    notification_setupObserver()
  }
}

// MARK: - ContentViewModelError

enum ContentViewModelError: LocalizedError {
  case failedToSendResource(String)
  case failedToDeleteArchives(String)
  case unknown

  var errorDescription: String? {
    switch self {
    case .failedToSendResource:
      return "Failed to Send Resource"
    case .failedToDeleteArchives:
      return "Failed to Delete Archives"
    case .unknown:
      return "Unknown Error"
    }
  }

  var recoverySuggestion: String? {
    switch self {
    case .failedToSendResource(let errorMessage):
      return errorMessage
    case .failedToDeleteArchives(let errorMessage):
      return errorMessage
    case .unknown:
      return nil
    }
  }
}
