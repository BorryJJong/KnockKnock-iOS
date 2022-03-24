//
//  FeedWritePresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWritePresenterProtocol: AnyObject {
  var view: FeedWriteViewProtocol? { get set }
}

final class FeedWritePresenter: FeedWritePresenterProtocol {
  weak var view: FeedWriteViewProtocol?


}
