//
//  HomePresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import UIKit

protocol HomePresenterProtocol {
  var view: HomeViewProtocol? { get set }

  func presentHotPostList(hotPostList: [HotPost])
}

final class HomePresenter: HomePresenterProtocol {
  weak var view: HomeViewProtocol?

  func presentHotPostList(hotPostList: [HotPost]) {
    self.view?.fetchHotPostList(hotPostList: hotPostList)
  }
}
