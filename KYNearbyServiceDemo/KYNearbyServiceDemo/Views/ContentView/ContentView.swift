//
//  ContentView.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 28/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI
import KYNearbyService

struct ContentView: View {

  @State private var navigationPath = NavigationPath()

#if os(macOS)
  @EnvironmentObject var viewModel: ContentViewModel
  @EnvironmentObject var nearbyConnectionViewModel: KYNearbyConnectionViewModel
#else
  @StateObject var viewModel = ContentViewModel()
  @StateObject private var nearbyConnectionViewModel = KYNearbyConnectionViewModel(
    visibleToOthersAs: UserDefaults.demo_nearbyServiceCustomDisplayName(),
    theme: .demo_makeTheme(),
    formWrapped: false,
    hasSendableData: false
  )
#endif // os(macOS)

  // MARK: - View

  var body: some View {
    NavigationStack(path: $navigationPath) {
      self.rootContentView
        .navigationDestination(for: String.self) { destination in
          if destination == "archives" {
            _archivesSelectionView()
          }
        }
    }
  }

  // MARK: - Private

  private var rootContentView: some View {
    ZStack {
      Color.demo_defaultBackground
        .ignoresSafeArea()

      Form {
        _fileSelectionSection()

        KYNearbyConnectionView(viewModel: self.nearbyConnectionViewModel)
      }
#if os(macOS)
      .formStyle(.grouped)
#endif // os(macOS)
      .demo_nearbyServiceDemoHideScrollContentBackground()
      .animation(.ky_nearbyConnectionViewAnimation, value: self.nearbyConnectionViewModel.peersCount)
    }
    .navigationTitle("Nearby Demo")
#if os(iOS)
    .navigationBarTitleDisplayMode(.inline)
#endif // os(iOS)

    // View Lifecycle
    //
    .onAppear(perform: self.nearbyConnectionViewModel.didPresentView)
    .onDisappear(perform: self.nearbyConnectionViewModel.didDismissView)

    // Alert
    //
    .alert(
      isPresented: .constant(self.viewModel.error != nil),
      error: self.viewModel.error,
      actions: { _ in
        Button("OK", role: .cancel) {
          self.viewModel.error = nil
        }
      },
      message: { localizedError in
        if let recoverySuggestion = localizedError.recoverySuggestion {
          Text(recoverySuggestion)
        }
      }
    )
  }

  // MARK: - Private (File Selection)

  private func _fileSelectionSection() -> some View {
    Section {
      Text(self.viewModel.selectedFilename ?? "None")
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .listRowBackground(Color.demo_secondaryBackground)
        .foregroundColor(.demo_defaultContent)

#if os(iOS)
      Button("Browse Archives", systemImage: "archivebox") {
        self.navigationPath.append("archives")
      }
      .foregroundStyle(Color.demo_accent)
#endif // os(iOS)

    } header: {
      Text("File to Send").foregroundColor(.demo_secondaryContent)
    }
  }

  private func _archivesSelectionView() -> some View {
    ArchivesSelectionView()
      .environmentObject(self.viewModel)
      .onChange(of: self.viewModel.selectedFilename) { _ in
        let hasSendableData: Bool = self.viewModel.selectedFilename != nil
        if self.nearbyConnectionViewModel.hasSendableData != hasSendableData {
          self.nearbyConnectionViewModel.hasSendableData = hasSendableData
        }
        self.navigationPath.removeLast()
      }
  }
}

// MARK: - Preview

#if DEBUG
#Preview {
  ContentView()
}
#endif // DEBUG
