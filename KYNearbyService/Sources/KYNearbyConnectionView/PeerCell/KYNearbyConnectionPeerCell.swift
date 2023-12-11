//
//  KYNearbyConnectionPeerCell.swift
//  KYNearbyService
//
//  Created by Kjuly on 27/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI
import MultipeerConnectivity

struct KYNearbyConnectionPeerCell: View {

  @ObservedObject var item: KYNearbyPeerModel

  @EnvironmentObject var viewModel: KYNearbyConnectionViewModel
  @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

  @State var isPresentingActions: Bool = false

  // MARK: - Init

  init(item: KYNearbyPeerModel) {
    self.item = item
  }

  // MARK: - View

  var body: some View {
#if DEBUG
    let _ = Self._printChanges() // swiftlint:disable:this redundant_discardable_let
#endif
    VStack(spacing: 0) {
      _contentRows()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      // End editing if needed.
      self.viewModel.endEditingIfNeeded()
      // Present action sheet for item if needed.
      if hasActions(for: self.item.connectionStatus) {
        self.isPresentingActions = true
      }
    }
    .confirmationDialog(self.item.displayName, isPresented: $isPresentingActions) {
      actions(for: self.item)
    }
  }

  // MARK: - Private

  private func _isCompactWidth() -> Bool {
    if KYNearbyConnectionView.isCompactDevice {
      return self.verticalSizeClass != .compact
    } else {
      return false
    }
  }

  private func _statusColor() -> Color {
    switch self.item.connectionStatus {
    case .connected: return self.greenStatusColor
    case .blocked: return self.redStatusColor
    default:
      return self.secondaryContentColor
    }
  }

  // MARK: - Private (Content View)

  @ViewBuilder
  private func _contentRows() -> some View {
    //
    // Main Content (1st Row)
    //
    _mainContentRow()

    //
    // Secondary Content (2nd Row)
    //
    if self.item.connectionStatus == .connecting {
      if _isCompactWidth() {
        _connectingIndicator()
      }

    } else if self.item.processStatus == .processing {
      // Data Processing Bar
      ProgressView(value: self.item.progress?.fractionCompleted ?? 0)
        .progressViewStyle(.linear)
        .padding(.leading, KYNearbyConnectionViewDimension.PeerCell.secondaryContentLeadingPadding)

      // Data Processing Details (For Compact Device Case)
      if _isCompactWidth() {
        _dataProcessingDetails(forCompact: true)
      }
    }

    //
    // Tertiary Content (3rd Row)
    //
    if self.item.processErrorMessage != nil {
      _errorLabel()
    }
  }

  @ViewBuilder
  private func _mainContentRow() -> some View {
    HStack(alignment: .center, spacing: KYNearbyConnectionViewDimension.PeerCell.horizontalSpacing) {
      // Peer Status & Name
      _peerStatusAndNameLabel()

      if self.item.connectionStatus == .connected {
        if self.item.processStatus == .processing {
          // Data Processing Details (For Wide Device Case)
          if !_isCompactWidth() {
            _dataProcessingDetails(forCompact: false)
          }
          // Terminate Data Processing Button
          _terminateDataProcessingButton()

        } else if self.item.processStatus == .pending {
          ProgressView()

        } else if self.viewModel.hasSendableData {
          _sendButton()
        }

      } else if self.item.connectionStatus == .connecting {
        if !_isCompactWidth() {
          _connectingIndicator()
        }

      } else if self.item.connectionStatus == .blocked || self.item.connectionStatus == .declined {
        _connectionStatusIndicatorLabel()
      }
    }
    .frame(maxWidth: .infinity)
  }

  // MARK: - Private (View Element)

  @ViewBuilder
  private func _peerStatusAndNameLabel() -> some View {
    Image(systemName: KYNearbyConnectionViewIconName.peerStatusIndicator)
      .foregroundColor(_statusColor())
      .frame(width: KYNearbyConnectionViewDimension.PeerCell.peerStatusIndicatorSideLength)
    Text(self.item.displayName)
      .font(self.labelFont)
      .foregroundColor(self.defaultContentColor)
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private func _connectionStatusIndicatorLabel() -> some View {
    Text(self.item.connectionStatus.text)
      .font(self.smallFontInBold)
      .padding(.vertical, KYNearbyConnectionViewDimension.Margin.level_1)
      .padding(.horizontal, KYNearbyConnectionViewDimension.Margin.level_2)
      .foregroundColor(.white)
      .background(Color.black)
      .cornerRadius(KYNearbyConnectionViewDimension.ViewCornerRadius.regular)
  }

  @ViewBuilder
  private func _connectingIndicator() -> some View {
    HStack(spacing: KYNearbyConnectionViewDimension.Margin.level_2) {
      Text("LS:Connection Status:Connecting".ky_nearbyServiceLocalized)
        .font(self.labelFont)
        .foregroundColor(self.secondaryContentColor)
        .frame(maxWidth: .infinity, alignment: .trailing)
      ProgressView()
    }
  }

  @ViewBuilder
  private func _sendButton() -> some View {
    Button {
      p_askToSendResource(for: self.item)
    } label: {
      Text("LS:SEND".ky_nearbyServiceLocalized)
        .font(self.smallFontInBold)
    }
    .buttonStyle(.bordered)
  }

  @ViewBuilder
  private func _terminateDataProcessingButton() -> some View {
    Button {
      KYNearbyService.shared.terminateProcessingIfNeededForItem(self.item)
    } label: {
      Image(systemName: KYNearbyConnectionViewIconName.terminateProcessing)
        .foregroundColor(self.accentColor)
    }
    .frame(width: KYNearbyConnectionViewDimension.IconButtonSideLength.small,
           height: KYNearbyConnectionViewDimension.IconButtonSideLength.regular,
           alignment: .trailing)
  }

  @ViewBuilder
  private func _dataProcessingDetails(forCompact: Bool) -> some View {
    if forCompact {
      HStack {
        Text(self.item.processTitle ?? "")
          .font(self.smallFontInBold)
          .foregroundColor(self.secondaryContentColor)
        Text(self.item.progress?.localizedAdditionalDescription ?? "")
          .font(self.smallFont)
          .foregroundColor(self.secondaryContentColor)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding(.leading, KYNearbyConnectionViewDimension.PeerCell.secondaryContentLeadingPadding)
    } else {
      VStack(alignment: .trailing) {
        Text(self.item.processTitle ?? "")
          .font(self.smallFontInBold)
          .foregroundColor(self.defaultContentColor)
        Text(self.item.progress?.localizedAdditionalDescription ?? "")
          .font(self.smallFont)
          .foregroundColor(self.secondaryContentColor)
      }
    }
  }

  @ViewBuilder
  private func _errorLabel() -> some View {
    Text(self.item.processErrorMessage ?? "")
      .font(self.smallFont)
      .foregroundColor(self.redStatusColor)
      .lineLimit(3)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, KYNearbyConnectionViewDimension.PeerCell.secondaryContentLeadingPadding)
  }

  // MARK: - Internal

  func p_askToSendResource(for item: KYNearbyPeerModel) {
    NotificationCenter.default.post(name: .KYNearbyService.shouldSendResource, object: item)
  }
}

// MARK: - Font & Color Getter Extension

extension KYNearbyConnectionPeerCell {

  // MARK: - Font

  fileprivate var labelFont: Font {
    return self.viewModel.theme.labelFont
  }

  fileprivate var smallFont: Font {
    return self.viewModel.theme.smallFont
  }

  fileprivate var smallFontInBold: Font {
    return self.viewModel.theme.smallFontInBold
  }

  // MARK: - Color

  fileprivate var accentColor: Color {
    return self.viewModel.theme.accentColor
  }

  fileprivate var defaultContentColor: Color {
    return self.viewModel.theme.defaultContentColor
  }

  fileprivate var secondaryContentColor: Color {
    return self.viewModel.theme.secondaryContentColor
  }

  fileprivate var greenStatusColor: Color {
    return self.viewModel.theme.greenStatusColor
  }

  fileprivate var redStatusColor: Color {
    return self.viewModel.theme.redStatusColor
  }
}

// MARK: - KYNearbyConnectionPeerCell Previews

#if DEBUG
struct KYNearbyConnectionPeerCell_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = KYNearbyConnectionViewModel(formWrapped: true, hasSendableData: true, populateFakePeers: false)

    let items: [KYNearbyPeerModel] = KYNearbyPeerModel.debug_makePeersForAllCases()
    Form {
      Section {
        ForEach(items, id: \.peerID) { item in
          KYNearbyConnectionPeerCell(item: item)
            .environmentObject(viewModel)
        }
      }
      .listRowBackground(viewModel.theme.secondaryBackgroundColor)
    }
    .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
  }
}
#endif // END #if DEBUG
