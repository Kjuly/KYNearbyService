//
//  KYNearbyService+Sending.swift
//  KYNearbyService
//
//  Created by Kjuly on 8/2/2022.
//  Copyright © 2022 Kaijie Yu. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import KYLogger

extension KYNearbyService {

  @MainActor
  @objc
  public func sendResource(
    for item: KYNearbyPeerModel,
    at resourceURL: URL,
    withName resourceName: String,
    completion: @escaping (String?) -> Void
  ) {
    /*
    // TODO: Use this version after removed ObjC supports, which need to update status
    //   for refreshing cell first (refer to VMSharePresenter+PeerAction.m):
    //
    //   [item startProcessingForReceiving:NO];
    //   [weakSelf.viewInterface updateCollectionWithLatestDataSourceSnapshotAnimated:YES];
    //
    guard
      let session = self.session,
      item.processStatus == .pending
    else {
      return
    }*/
    guard let session = self.session else {
      return
    }

    item.startProcessing(forReceiving: false)

    let progress: Progress? = session.sendResource(at: resourceURL, withName: resourceName, toPeer: item.peerID) { error in
      DispatchQueue.main.async {
        item.progressCounter = 0
        item.progress = nil

        if let error {
          if let mcError = error as? MCError, mcError.code == .cancelled {
            KYLog(.warn, error.localizedDescription)
            completion(nil)

          } else {
            let sendingResultErrorMessage = error.localizedDescription
            KYLog(.error, sendingResultErrorMessage)
            completion(sendingResultErrorMessage)
          }
        } else {
          completion(nil)
        }
      }
    }

    guard let progress else {
      item.doneProcessing(with: "LS:Error:Faled to send resource.".ky_nearbyServiceLocalized)
      return
    }
    progress.kind = .file
    progress.fileOperationKind = .copying

    // TODO: Provide localized description.
    // progress.localizedDescription
    // progress.localizedAdditionalDescription

    // TODO: Provide handlers.
    // progress.pausingHandler()
    // progress.resumingHandler()
    // progress.cancellationHandler()

    item.progress = progress
  }
}
