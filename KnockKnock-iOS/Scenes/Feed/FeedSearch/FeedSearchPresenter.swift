//
//  FeedSearchPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchPresenterProtocol {
  var view: FeedSearchViewProtocol? { get set }
}

final class FeedSearchPresenter: FeedSearchPresenterProtocol {
  var view: FeedSearchViewProtocol?

}
