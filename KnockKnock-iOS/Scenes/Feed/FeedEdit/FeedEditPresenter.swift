//
//  FeedEditPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditPresenterProtocol: AnyObject {
  var view: FeedEditViewProtocol? { get set}
  func presentOriginPost(feedDetail: FeedDetail) 
}

final class FeedEditPresenter: FeedEditPresenterProtocol {

  weak var view: FeedEditViewProtocol?

  func presentOriginPost(feedDetail: FeedDetail) {
    self.view?.fetchOriginPost(feedDetail: feedDetail)
  }
}
