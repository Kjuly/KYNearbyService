//
//  ArchivesSelectionView.swift
//  KYNearbyServiceDemo
//
//  Created by Kjuly on 31/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI
import KYNearbyService

struct ArchivesSelectionView: View {

  @EnvironmentObject var viewModel: ContentViewModel

  @State private var isLoadingArchives: Bool = true
  @State private var filenames: [String] = []

  @State private var isPresentingDeletionDialog: Bool = false
  @State private var isDeletingArchives: Bool = false

  // MARK: - View

  var body: some View {
    ZStack {
      Color.demo_defaultBackground
        .ignoresSafeArea()

      _contentView()
        .demo_nearbyServiceDemoHideScrollContentBackground()
    }
    .navigationTitle("Archives")
#if os(iOS)
    .navigationBarTitleDisplayMode(.inline)
#endif
    .onReceive(NotificationCenter.default.publisher(for: .KYNearbyService.didReceiveResource)) { _ in
      _loadArchives()
    }
    .toolbar {
      ToolbarItemGroup(placement: .confirmationAction) {
        if !self.filenames.isEmpty {
          Button(role: .destructive) {
            self.isPresentingDeletionDialog = true
          } label: {
            Image(systemName: "trash")
              .foregroundColor(self.isDeletingArchives ? .demo_disabledStatus : .demo_redStatus)
          }
          .disabled(self.isDeletingArchives)
          .confirmationDialog("", isPresented: $isPresentingDeletionDialog, titleVisibility: .hidden) {
            Button("Clean All", role: .destructive) {
              self.isDeletingArchives = true
            }
            Button("Cancel", role: .cancel) {
              self.isPresentingDeletionDialog = false
            }
          } message: {
            Text("Would you like to clean all archives?")
          }
        }
      }
    }
  }

  // MARK: - Private

  @ViewBuilder
  private func _contentView() -> some View {
    //
    // Loading View
    if self.isLoadingArchives {
      List {
        Text("Filename A")
        Text("Filename B")
        Text("Filename C")
      }
      .redacted(reason: .placeholder)
      .onAppear(perform: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          _loadArchives()
        }
      })
    }
    //
    // Deleting Archives
    else if self.isDeletingArchives {
      HStack(spacing: 5) {
        ProgressView()
        Text("Deleting...")
          .font(.demo_label)
          .foregroundColor(.demo_defaultContent)
      }
      .onAppear(perform: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          _deleteAllArchives()
        }
      })
    }
    //
    // Empty View
    else if self.filenames.isEmpty {
      VStack(alignment: .center, spacing: 5) {
        Text("No Files")
          .font(.demo_labelInBold)
          .foregroundColor(.demo_defaultContent)

        Text("""
You can put some testing files into the \"/\(KYNearbyServiceDemoApp.archivesFolderURL.lastPathComponent)\" folder,
which is under the app document directory.
""")
        .multilineTextAlignment(.center)
        .font(.demo_small)
        .foregroundColor(.demo_secondaryContent)
      }
      .padding(.horizontal, 15)
    }
    //
    // List View
    else {
      List(self.filenames, id: \.self, selection: $viewModel.selectedFilename) {
        Text($0).foregroundColor(.demo_defaultContent)
      }
    }
  }

  private func _loadArchives() {
    let archivesFolderURL: URL = KYNearbyServiceDemoApp.archivesFolderURL
    let documentContents: [URL]? = try? FileManager.default.contentsOfDirectory(
      at: archivesFolderURL,
      includingPropertiesForKeys: [.nameKey],
      options: .skipsHiddenFiles)

    if let documentContents, !documentContents.isEmpty {
      self.filenames = documentContents.map { $0.lastPathComponent }.sorted(by: <)
    } else {
      self.filenames = []
    }
    self.isLoadingArchives = false
  }

  private func _deleteAllArchives() {
    do {
      try KYNearbyService.cleanAllArchives()
      self.filenames = []
      self.viewModel.selectedFilename = nil
    } catch {
      self.viewModel.error = .failedToDeleteArchives(error.localizedDescription)
    }
    self.isDeletingArchives = false
  }
}
