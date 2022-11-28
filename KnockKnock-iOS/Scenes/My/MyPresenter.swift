//
//  MyPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import UIKit

protocol MyPresenterProtocol {
  var view: MyViewProtocol? { get set }

  func presentMenuData(myMenu: MyMenu)
}

final class MyPresenter: MyPresenterProtocol {

  weak var view: MyViewProtocol?

  func presentMenuData(myMenu: MyMenu) {
    self.view?.fetchMenuData(menuData: myMenu)
  }
}
