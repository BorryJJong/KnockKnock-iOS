//
//  NotificationCenter+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/29.
//

import Foundation

extension Notification.Name {
  // My
  static let signInCompleted = Notification.Name("signInCompleted")
  static let signOutCompleted = Notification.Name("signOutCompleted")

  // Feed
  static let feedRefreshAfterSigned = Notification.Name("feedRefreshAfterSigned")
  static let feedRefreshAfterUnsigned = Notification.Name("feedRefreshAfterUnsigned")
}
