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
  static let profileUpdated = Notification.Name("profileUpdated")

  // Feed
  static let feedListRefreshAfterSigned = Notification.Name("feedRefreshAfterSigned")
  static let feedListRefreshAfterUnsigned = Notification.Name("feedRefreshAfterUnsigned")

  static let feedMainRefreshAfterDelete = Notification.Name("feedMainRefreshAfterDelete")
  static let feedListRefreshAfterDelete = Notification.Name("feedListRefreshAfterDelete")

  static let feedListRefreshAfterEdited = Notification.Name("feedListRefreshAfterEdited")
  static let feedDetailRefreshAfterEdited = Notification.Name("feedDetailRefreshAfterEdited")

  static let postLike = Notification.Name("postLike")
  static let postLikeCancel = Notification.Name("postLikeCancel")
}
