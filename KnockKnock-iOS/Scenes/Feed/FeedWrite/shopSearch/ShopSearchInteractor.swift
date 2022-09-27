//
//  ShopSearchInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchInteractorProtocol {
  var worker: ShopSearchWorkerProtocol? { get set }
  var presenter: ShopSearchPresenterProtocol? { get set }
}

final class ShopSearchInteractor: ShopSearchInteractorProtocol {

  var worker: ShopSearchWorkerProtocol?
  var presenter: ShopSearchPresenterProtocol?

}
