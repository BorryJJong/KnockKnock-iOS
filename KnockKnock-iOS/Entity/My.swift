//
//  My.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/17.
//

import Foundation

typealias MyMenu = [MyItemList]

struct MyItemList {
  let section: MySection
  let myItems: [MyItem]
}

struct MyItem {
  let title: String
  let type: MyType
}
