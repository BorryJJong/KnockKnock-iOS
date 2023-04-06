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
  static let pushSettingUpdated = Notification.Name("pushSettingUpdated")

  // Feed
  static let feedListRefreshAfterSigned = Notification.Name("feedListRefreshAfterSigned")
  static let feedListRefreshAfterUnsigned = Notification.Name("feedListRefreshAfterUnsigned")

  static let feedMainRefreshAfterSigned = Notification.Name("feedMainRefreshAfterSigned")
  static let feedMainRefreshAfterUnsigned = Notification.Name("feedMainRefreshAfterUnsigned")

  static let feedMainRefreshAfterDelete = Notification.Name("feedMainRefreshAfterDelete")
  static let feedListRefreshAfterDelete = Notification.Name("feedListRefreshAfterDelete")

  static let feedListRefreshAfterEdited = Notification.Name("feedListRefreshAfterEdited")
  static let feedDetailRefreshAfterEdited = Notification.Name("feedDetailRefreshAfterEdited")

  static let feedListRefreshAfterWrite = Notification.Name("feedListRefreshAfterWrite")
  static let feedMainRefreshAfterWrite = Notification.Name("feedMainRefreshAfterWrite")

  static let postLikeToggled = Notification.Name("postLikeToggled")
  static let pushFeedMain = Notification.Name("pushFeed")
  
  static let feedListRefreshAfterBlocked = Notification.Name("feedListRefreshAfterBlocked")
  static let feedMainRefreshAfterBlocked = Notification.Name("feedMainRefreshAfterBlocked")

  // Comment
  static let feedListCommentRefreshAfterDelete = Notification.Name("feedListCommentRefreshAfterDelete")
  static let feedListCommentRefreshAfterAdd = Notification.Name("feedListCommentRefreshAfterAdd")

  static let feedDetailCommentRefreshAfterDelete = Notification.Name("feedDetailCommentRefreshAfterDelete")
  static let feedDetailCommentRefreshAfterAdd = Notification.Name("feedDetailCommentRefreshAfteAdd")
}
