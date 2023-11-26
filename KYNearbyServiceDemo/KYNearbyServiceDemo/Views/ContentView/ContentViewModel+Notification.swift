//
//  ContentViewModel+Notification.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import KYNearbyService

extension ContentViewModel {

  func notification_setupObserver() {
    let defaultCenter = NotificationCenter.default
    defaultCenter.addObserver(
      self,
      selector: #selector(_handleKYNearbyServiceDidUpdatePeerDisplayNameNotification),
      name: .KYNearbyService.didUpdatePeerDisplayName,
      object: nil)
    defaultCenter.addObserver(
      self,
      selector: #selector(_handleKYNearbyServiceShouldSendResourceNotification),
      name: .KYNearbyService.shouldSendResource,
      object: nil)
  }

  func notification_removeObserver() {
    let defaultCenter = NotificationCenter.default
    defaultCenter.removeObserver(self, name: .KYNearbyService.didUpdatePeerDisplayName, object: nil)
    defaultCenter.removeObserver(self, name: .KYNearbyService.shouldSendResource, object: nil)
  }

  // MARK: - Private (Custom Display Name)

  @objc private func _handleKYNearbyServiceDidUpdatePeerDisplayNameNotification(_ note: Notification) {
    if let name = note.object as? String {
      UserDefaults.demo_setNearbyServiceCustomDisplayName(name)
    }
  }

  // MARK: - Private (Send Resoruce)

  @objc private func _handleKYNearbyServiceShouldSendResourceNotification(_ note: Notification) {
    guard
      let filename = self.selectedFilename,
      let item = note.object as? KYNearbyPeerModel
    else {
      return
    }

    DispatchQueue.main.async {
      item.prepareForProcessing()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Simulate the file preparing step.
      self._startSendingFile(filename, to: item)
    }
  }

  @MainActor
  private func _startSendingFile(_ filename: String, to item: KYNearbyPeerModel) {
    let fileURL = KYNearbyServiceDemoApp.archivesFolderURL.appendingPathComponent(filename)
    KYNearbyService.shared.sendResource(for: item, at: fileURL, withName: filename) { errorMessage in
      item.doneProcessing(with: errorMessage)

      if let errorMessage {
        self.error = .failedToSendResource(errorMessage)
      }
    }
  }
}
