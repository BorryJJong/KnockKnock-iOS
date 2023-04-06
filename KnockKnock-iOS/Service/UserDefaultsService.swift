//
//  UserDefaultsService.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/04.
//

import Foundation

import Then

extension UserDefaultsKey: ExpressibleByStringLiteral {
  public init(unicodeScalarLiteral value: StringLiteralType) {
    self.init(key: value)
  }

  public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
    self.init(key: value)
  }

  public init(stringLiteral value: StringLiteralType) {
    self.init(key: value)
  }
}

extension UserDefaultsKey {
  static var accessToken: Key<String> { return "ACCESS_TOKEN" }
  static var refreshToken: Key<String> { return "REFRESH_TOKEN" }
  static var nickname: Key<String> { return "NICKNAME" }
  static var profileImage: Key<String> { return "PROFILE_IMAGE" }
}

protocol UserDefaultsServiceType: Then {
  func value<T>(forkey key: UserDefaultsKey<T>) -> T?
  func set<T>(value: T?, forkey key: UserDefaultsKey<T>)
  func remove<T>(forkey key: UserDefaultsKey<T>)
}

final class UserDefaultsService: UserDefaultsServiceType {

  private var defaults: UserDefaults {
    return UserDefaults.standard
  }

  func value<T>(forkey key: UserDefaultsKey<T>) -> T? {
    return self.defaults.value(forKey: key.key) as? T
  }

  func set<T>(value: T?, forkey key: UserDefaultsKey<T>) {
    self.defaults.set(value, forKey: key.key)
    self.defaults.synchronize()
  }

  func remove<T>(forkey key: UserDefaultsKey<T>) {
    self.defaults.removeObject(forKey: key.key)
  }
}
