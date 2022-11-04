//
//  FeedWritePresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWritePresenterProtocol: AnyObject {
  var view: FeedWriteViewProtocol? { get set }

  func fetchProperty(propertyType: PropertyType, content: String)
}

final class FeedWritePresenter: FeedWritePresenterProtocol {
  weak var view: FeedWriteViewProtocol?

  func fetchProperty(propertyType: PropertyType, content: String) {
    self.view?.fetchProperty(propertyType: propertyType, content: content)
  }
}
