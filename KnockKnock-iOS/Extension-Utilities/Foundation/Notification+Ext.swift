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
  static let feedListRefreshAfterSigned = Notification.Name("feedRefreshAfterSigned")
  static let feedListRefreshAfterUnsigned = Notification.Name("feedRefreshAfterUnsigned")

  static let feedMainRefresh = Notification.Name("feedMainRefresh")
  static let feedListRefresh = Notification.Name("feedListRefresh")

  static let postLike = Notification.Name("postLike")
  static let postLikeCancel = Notification.Name("postLikeCancel")
}
