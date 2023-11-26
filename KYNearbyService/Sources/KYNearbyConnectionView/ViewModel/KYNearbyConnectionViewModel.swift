//
//  KYNearbyConnectionViewModel.swift
//  KYNearbyService
//
//  Created by Kjuly on 25/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

enum KYNearbyConnectionViewFocusedField: Hashable {
  case visibleToOthersAs
}

public class KYNearbyConnectionViewModel: ObservableObject {

  let theme: KYNearbyConnectionViewTheme
  let isFormWrapped: Bool

  @Published public var hasSendableData: Bool

  @Published var focusedField: KYNearbyConnectionViewFocusedField?

  @Published var shouldVisibleToOthers: Bool
  @Published var visibleToOthersAsPlaceholder: String
  @Published var visibleToOthersAsText: String
  var originalVisibleToOthersAsText: String

  @Published var peers: [KYNearbyPeerModel] = []
  @Published public var peersCount: Int = 0

  @Published var isDisconnectionEnabled: Bool

  var isObservedNotification: Bool = false

  // MARK: - Deinit

  deinit {
    if self.isObservedNotification {
      NotificationCenter.default.removeObserver(self)
    }
  }

  // MARK: - Init

  @MainActor
  public init(
    visibleToOthersAs peerDisplayName: String?,
    theme: KYNearbyConnectionViewTheme,
    formWrapped: Bool,
    hasSendableData: Bool
  ) {
    self.theme = theme
    self.isFormWrapped = formWrapped
    self.hasSendableData = hasSendableData

    let nearbyService = KYNearbyService.shared

    //
    // Visible to Others As
    self.shouldVisibleToOthers = nearbyService.isVisibleToOthers
    self.visibleToOthersAsPlaceholder = KYNearbyServiceConfiguration.visibleToOthersAsPlaceholder()

    let originalVisibleToOthersAsText = peerDisplayName ?? ""
    self.originalVisibleToOthersAsText = originalVisibleToOthersAsText
    self.visibleToOthersAsText = originalVisibleToOthersAsText

    //
    // Users Nearby
    self.peers = nearbyService.peers
    self.peersCount = nearbyService.peers.count

    //
    // Disconnection
    self.isDisconnectionEnabled = nearbyService.hasPeerConnected()

    //
    // Notification
    notification_setup()
  }

#if DEBUG
  @MainActor
  public convenience init(formWrapped: Bool, hasSendableData: Bool, populateFakePeers: Bool) {
    if populateFakePeers {
      KYNearbyService.shared.peers = KYNearbyPeerModel.debug_makePeersForAllCases()
    }
    self.init(
      visibleToOthersAs: nil,
      theme: .makeDefault(),
      formWrapped: formWrapped,
      hasSendableData: hasSendableData)
  }
#endif // END #if DEBUG

  // MARK: - View Lifecycle

  public func didPresentView() {
    if !self.isObservedNotification {
      self.isObservedNotification = true
      KYNearbyService.shared.setupSession(with: self.visibleToOthersAsText)
      notification_setup()
    }
    KYNearbyService.shared.browseOthers(true)
  }

  public func didDismissView() {
    KYNearbyService.shared.browseOthers(false)
  }

  // MARK: - Public

  @MainActor
  public func endEditingIfNeeded() {
    if self.focusedField != nil {
      self.focusedField = nil
    }
  }
}
