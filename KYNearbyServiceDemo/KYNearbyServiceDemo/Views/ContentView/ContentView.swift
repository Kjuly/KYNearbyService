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

  @State private var isPresentingArchivesList: Bool = false

#if os(macOS)
  @EnvironmentObject var viewModel: ContentViewModel
  @EnvironmentObject var nearbyConnectionViewModel: KYNearbyConnectionViewModel
#else
  @StateObject var viewModel = ContentViewModel()
  @StateObject private var nearbyConnectionViewModel = KYNearbyConnectionViewModel(
    visibleToOthersAs: UserDefaults.demo_nearbyServiceCustomDisplayName(),
    theme: .demo_makeTheme(),
    formWrapped: false,
    hasSendableData: false)
#endif

  // MARK: - View

  var body: some View {
    ZStack {
      Color.demo_defaultBackground
        .ignoresSafeArea()

      Form {
        _fileSelectionSection()

        KYNearbyConnectionView(viewModel: self.nearbyConnectionViewModel)
      }
#if os(macOS)
      .formStyle(.grouped)
#endif
      .demo_nearbyServiceDemoHideScrollContentBackground()
      .animation(.ky_nearbyConnectionViewAnimation, value: self.nearbyConnectionViewModel.peersCount)
    }
    .navigationTitle("Nearby Demo")
#if os(iOS)
    .navigationBarTitleDisplayMode(.inline)
#endif
    .onAppear(perform: {
      self.nearbyConnectionViewModel.didPresentView()
    })
    .onDisappear(perform: {
      self.nearbyConnectionViewModel.didDismissView()
    })
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
      })
  }

  // MARK: - Private (File Selection)

  @ViewBuilder
  private func _fileSelectionSection() -> some View {
    Section {
      Text(self.viewModel.selectedFilename ?? "None")
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .listRowBackground(Color.demo_secondaryBackground)
        .foregroundColor(.demo_defaultContent)

#if os(iOS)
      NavigationLink(isActive: $isPresentingArchivesList, destination: _archivesSelectionView) {
        Label("Browse Archives", systemImage: "archivebox")
          .foregroundColor(.demo_accent)
      }
#endif
    } header: {
      Text("File to Send").foregroundColor(.demo_secondaryContent)
    }
  }

  @ViewBuilder
  private func _archivesSelectionView() -> some View {
    ArchivesSelectionView()
      .environmentObject(self.viewModel)
      .onChange(of: self.viewModel.selectedFilename) { _ in
        let hasSendableData: Bool = self.viewModel.selectedFilename != nil
        if self.nearbyConnectionViewModel.hasSendableData != hasSendableData {
          self.nearbyConnectionViewModel.hasSendableData = hasSendableData
        }
        self.isPresentingArchivesList = false
      }
  }
}

#Preview {
  ContentView()
}
