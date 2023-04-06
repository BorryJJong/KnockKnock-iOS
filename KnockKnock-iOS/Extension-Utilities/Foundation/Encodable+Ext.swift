//
//  Encodable+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import Foundation

extension Encodable {
  func encode() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(
      with: data,
      options: .allowFragments
    ) as? [String: Any] else {
      throw NSError()
    }

    return dictionary
  }
}
