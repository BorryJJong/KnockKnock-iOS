//
//  ShopSearchPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchPresenterProtocol {
  var view: ShopSearchViewProtocol? { get set }
}

final class ShopSearchPresenter: ShopSearchPresenterProtocol {
  var view: ShopSearchViewProtocol?
}
