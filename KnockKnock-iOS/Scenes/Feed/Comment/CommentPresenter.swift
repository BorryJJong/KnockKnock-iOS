//
//  CommentPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentPresenterProtocol {
  var view: CommentViewProtocol? { get set }
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?
}
