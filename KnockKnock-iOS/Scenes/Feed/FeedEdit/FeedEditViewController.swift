//
//  FeedEditViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditViewProtocol: AnyObject {
  var interactor: FeedEditInteractorProtocol? { get set}
}

final class FeedEditViewController: BaseViewController<FeedEditView> {

  // MARK: - Properties

  var interactor: FeedEditInteractorProtocol?

  // MARK: - Life Cycle

 
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func setupConfigure() {

  }
}

// MARK: - FeedEdit View Protocol

extension FeedEditViewController: FeedEditViewProtocol {

}
