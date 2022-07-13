//
//  CommentViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

import Then
import KKDSKit

protocol CommentViewProtocol {
  var router: CommentRouterProtocol? { get set }
  var interactor: CommentInteractorProtocol? { get set }
}

final class CommentViewController: BaseViewController<CommentView> {
  var router: CommentRouterProtocol?
  var interactor: CommentInteractorProtocol?
}
