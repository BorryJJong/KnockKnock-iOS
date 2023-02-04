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
  static let feedListRefreshAfterDelete = Notification.Name("feedListRefreshedAfterDelete")

  static let postLikeToggled = Notification.Name("postLikeToggled")

  // Comment
  static let feedListCommentRefreshAfterDelete = Notification.Name("feedListCommentRefreshAfterDelete")
  static let feedListCommentRefreshAfterAdd = Notification.Name("feedListCommentRefreshAfterAdd")

  static let feedDetailCommentRefreshAfterDelete = Notification.Name("feedDetailCommentRefreshAfterDelete")
  static let feedDetailCommentRefreshAfterAdd = Notification.Name("feedDetailCommentRefreshAfteAdd")
}
