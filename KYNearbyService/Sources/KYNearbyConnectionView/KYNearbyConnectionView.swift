//
//  KYNearbyConnectionView.swift
//  KYNearbyService
//
//  Created by Kjuly on 25/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct KYNearbyConnectionView: View {

#if os(macOS)
  static let isCompactDevice: Bool = false
#else
  static let isCompactDevice: Bool = (UIDevice.current.userInterfaceIdiom == .phone)
#endif

  @ObservedObject var viewModel: KYNearbyConnectionViewModel

  @FocusState private var focusedField: KYNearbyConnectionViewFocusedField?
  @State private var isPresentingDisconnectionDialog: Bool = false

  // MARK: - Init

  public init(viewModel: KYNearbyConnectionViewModel) {
    self.viewModel = viewModel
  }

  // MARK: - View

  public var body: some View {
#if DEBUG
    let _ = Self._printChanges() // swiftlint:disable:this redundant_discardable_let
#endif
    _contentView()
      .onChange(of: self.focusedField) { newValue in
        self.viewModel.focusedField = newValue
      }
      .onChange(of: self.viewModel.focusedField) { newValue in
        self.focusedField = newValue
      }
#if os(iOS)
      .onReceive(NotificationCenter.default.publisher(for: UIScene.didEnterBackgroundNotification)) { _ in
        _endEditingIfNeeded()
      }
#endif
  }

  // MARK: - Private

  @ViewBuilder
  private func _contentView() -> some View {
    if self.viewModel.isFormWrapped {
      ZStack {
        self.defaultBackgroundColor
          .ignoresSafeArea()

        Form {
          _sections()
        }
        .ky_nearbyConnectionViewHideScrollContentBackground()
        .animation(.ky_nearbyConnectionViewAnimation, value: self.viewModel.peersCount)
      }
      .onAppear(perform: {
        self.viewModel.didPresentView()
      })
      .onDisappear(perform: {
        self.viewModel.didDismissView()
      })
    } else {
      _sections()
    }
  }

  @ViewBuilder
  private func _sections() -> some View {
    //
    // "Visible to Others As"
    Section {
      _visibleToOthersAsCell()
    } header: {
      Text("LS:VISIBLE TO OTHERS AS".ky_nearbyServiceLocalized)
        .foregroundColor(self.secondaryContentColor)
    } footer: {
      Text("LS:VISIBLE TO OTHERS AS:Footnote".ky_nearbyServiceLocalized)
        .foregroundColor(self.secondaryContentColor)
    }

    //
    // Users Nearby
    Section {
      if self.viewModel.peers.isEmpty {
        _noUserFoundView()
      } else {
        _usersNearbyView()
      }
    } header: {
      Text("LS:USERS NEARBY (CHOOSE 1 TO 7 INVITEES)".ky_nearbyServiceLocalized)
        .foregroundColor(self.secondaryContentColor)
    }

    //
    // Disconnect All
    Section {
      Button(role: .destructive) {
        _endEditingIfNeeded()
        self.isPresentingDisconnectionDialog = true
      } label: {
        HStack {
          Spacer()
          Text("LS:Disconnect All".ky_nearbyServiceLocalized)
            .foregroundColor(self.viewModel.isDisconnectionEnabled ? self.redStatusColor : self.disabledStatusColor)
          Spacer()
        }
      }
      .buttonStyle(.borderless)
      .listRowBackground(self.secondaryBackgroundColor)
      .disabled(!self.viewModel.isDisconnectionEnabled)
      .confirmationDialog("", isPresented: $isPresentingDisconnectionDialog, titleVisibility: .hidden) {
        Button("LS:Disconnect All".ky_nearbyServiceLocalized, role: .destructive) {
          self.viewModel.didPressDisconnectAllButton()
        }
        Button("LS:Cancel".ky_nearbyServiceLocalized, role: .cancel) {
          self.isPresentingDisconnectionDialog = false
        }
      } message: {
        Text("LS:Disconnect All:Message".ky_nearbyServiceLocalized)
      }
    }
  }

  // MARK: - Private (Visible to Others As)

  private func _visibleToOthersAsCell() -> some View {
    HStack {
      _visibleToOthersAsTextField()

      Toggle("", isOn: $viewModel.shouldVisibleToOthers)
        .labelsHidden()
        .onChange(of: self.viewModel.shouldVisibleToOthers) { newValue in
          self.viewModel.didChangeVisibleToOthersSwitch(newValue)
        }
    }
    .listRowBackground(self.secondaryBackgroundColor)
  }

  private func _visibleToOthersAsTextField() -> some View {
    TextField(
      "",
      text: $viewModel.visibleToOthersAsText,
      prompt: Text(self.viewModel.visibleToOthersAsPlaceholder)
    )
#if os(iOS)
    .textInputAutocapitalization(.never)
#endif
    .autocorrectionDisabled()
    .focused($focusedField, equals: .visibleToOthersAs)
    .onChange(of: self.focusedField, perform: { [oldValue = self.focusedField] newValue in
      if oldValue == .visibleToOthersAs && newValue != .visibleToOthersAs {
        self.viewModel.didEndEditingVisibleToOthersAs(self.viewModel.visibleToOthersAsText)
      }
    })
    .onSubmit {
      self.focusedField = nil
    }
    .submitLabel(.done)
  }

  // MARK: - Private (Users Nearby)

  private func _noUserFoundView() -> some View {
    VStack(alignment: .center, spacing: KYNearbyConnectionViewDimension.Margin.level_1, content: {
      Text("LS:No User Found:Title".ky_nearbyServiceLocalized)
        .font(self.labelFontInBold)
        .foregroundColor(self.defaultContentColor)
      Text("LS:No User Found:Message".ky_nearbyServiceLocalized)
        .font(self.smallFont)
        .multilineTextAlignment(.center)
        .foregroundColor(self.secondaryContentColor)
    })
    .frame(maxWidth: .infinity)
    .listRowBackground(self.defaultBackgroundColor)
  }

  private func _usersNearbyView() -> some View {
    ForEach(self.viewModel.peers, id: \.peerID) { item in
      KYNearbyConnectionPeerCell(item: item)
        .environmentObject(self.viewModel)
    }
  }

  // MARK: - Private (Others)

  private func _endEditingIfNeeded() {
    if self.focusedField != nil {
      self.focusedField = nil
    }
  }
}

// MARK: - Font & Color Getter Extension

extension KYNearbyConnectionView {

  // MARK: - Font

  fileprivate var labelFontInBold: Font {
    return self.viewModel.theme.labelFontInBold
  }

  fileprivate var smallFont: Font {
    return self.viewModel.theme.smallFont
  }

  // MARK: - Color

  fileprivate var defaultContentColor: Color {
    return self.viewModel.theme.defaultContentColor
  }

  fileprivate var secondaryContentColor: Color {
    return self.viewModel.theme.secondaryContentColor
  }

  fileprivate var defaultBackgroundColor: Color {
    return self.viewModel.theme.defaultBackgroundColor
  }

  fileprivate var secondaryBackgroundColor: Color {
    return self.viewModel.theme.secondaryBackgroundColor
  }

  fileprivate var redStatusColor: Color {
    return self.viewModel.theme.redStatusColor
  }

  fileprivate var disabledStatusColor: Color {
    return self.viewModel.theme.disabledStatusColor
  }
}

// MARK: - KYNearbyConnectionView Previews

#if DEBUG
struct KYNearbyConnectionView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = KYNearbyConnectionViewModel(formWrapped: true, hasSendableData: true, populateFakePeers: true)
    KYNearbyConnectionView(viewModel: viewModel)
      .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
  }
}
#endif // END #if DEBUG
