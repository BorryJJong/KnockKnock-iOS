//
//  UserDefaultsKey.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/07.
//

import Foundation

struct UserDefaultsKey<T> {
  typealias Key<T> = UserDefaultsKey<T>
  let key: String
}
