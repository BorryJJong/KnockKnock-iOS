//
//  My.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/17.
//

import Foundation

typealias MyMenu = [MySection]

/// Section별 item
struct MySection {
  let title: MySectionType
  let myItems: [MyItem]
}

/// Item 별 세부 정보
/// title: 제목
/// type:  accessory type
struct MyItem {
  let title: String
  let type: MyType
}
