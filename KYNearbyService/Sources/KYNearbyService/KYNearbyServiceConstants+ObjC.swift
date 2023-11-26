//
//  KYNearbyServiceConstants+ObjC.swift
//  KYNearbyService
//
//  Created by Kjuly on 12/11/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

// MARK: - Notification Name

@objc
extension NSNotification {

  public static let KYNearbyServiceDidUpdatePeerDisplayNameNotification = Notification.Name.KYNearbyService.didUpdatePeerDisplayName

  public static let KYNearbyServiceDidStartReceivingResourceNotification = Notification.Name.KYNearbyService.didStartReceivingResource
  public static let KYNearbyServiceDidReceiveResourceNotification = Notification.Name.KYNearbyService.didReceiveResource

  public static let KYNearbyServicePeerDidChangeStateNotification = Notification.Name.KYNearbyService.peerDidChangeState
  public static let KYNearbyServiceFoundPeerNotification = Notification.Name.KYNearbyService.foundPeer
  public static let KYNearbyServiceLostPeerNotification = Notification.Name.KYNearbyService.lostPeer
  public static let KYNearbyServiceBrowsingErrorNotification = Notification.Name.KYNearbyService.browsingError
}

// MARK: - Notification UserInfo Key

@objcMembers
public class KYNearbyServiceNotificationUserInfoKeyObjC: NSObject {
  // public static let peerID = KYNearbyServiceNotificationUserInfoKey.peerID
  public static let peerItem = KYNearbyServiceNotificationUserInfoKey.peerItem
  // public static let state = KYNearbyServiceNotificationUserInfoKey.state
  public static let filename = KYNearbyServiceNotificationUserInfoKey.filename
  public static let url = KYNearbyServiceNotificationUserInfoKey.url
  public static let extraActionInfo = KYNearbyServiceNotificationUserInfoKey.extraActionInfo
  public static let errorMessage = KYNearbyServiceNotificationUserInfoKey.errorMessage
}
