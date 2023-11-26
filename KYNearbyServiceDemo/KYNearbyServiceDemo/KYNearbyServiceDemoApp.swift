//
//  KYNearbyServiceDemoApp.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 23/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI
import KYLogger
import KYNearbyService

@main
struct KYNearbyServiceDemoApp: App {

  static let archivesFolderURL: URL = KYNearbyServiceDefaultFolderURL.archives

#if os(macOS)
  @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

  @StateObject private var viewModel = ContentViewModel()

  @StateObject private var nearbyConnectionViewModel = KYNearbyConnectionViewModel(
    visibleToOthersAs: UserDefaults.demo_nearbyServiceCustomDisplayName(),
    theme: .demo_makeTheme(),
    formWrapped: false,
    hasSendableData: false)
#endif

  // MARK: - Init

  init() {
    KYLog(.notice, "App Document Directory: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])")

    // Setup KYNearbyService
    KYNearbyService.setup(with: KYNearbyServiceConfiguration(
      serviceType: "nearby-demo",
      archivesFolderURL: KYNearbyServiceDemoApp.archivesFolderURL,
      tempFolderURL: KYNearbyServiceDefaultFolderURL.temp,
      viewInterface: nil))
#if DEBUG
//    KYNearbyService.shared.debug_populateMockPeers()
#endif
  }

  var body: some Scene {
    WindowGroup {
#if os(iOS)
      NavigationView {
        ContentView()
      }
      .navigationViewStyle(.stack)
#else
      NavigationSplitView(columnVisibility: $columnVisibility) {
        ArchivesSelectionView()
          .environmentObject(self.viewModel)
          .onChange(of: self.viewModel.selectedFilename) { _ in
            let hasSendableData: Bool = self.viewModel.selectedFilename != nil
            if self.nearbyConnectionViewModel.hasSendableData != hasSendableData {
              self.nearbyConnectionViewModel.hasSendableData = hasSendableData
            }
          }
      } detail: {
        ContentView()
          .environmentObject(self.viewModel)
          .environmentObject(self.nearbyConnectionViewModel)
      }
#endif
    }
  }
}
