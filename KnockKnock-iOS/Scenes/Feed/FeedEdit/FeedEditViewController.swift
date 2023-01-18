//
//  FeedEditViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

import KKDSKit

protocol FeedEditViewProtocol: AnyObject {
  var interactor: FeedEditInteractorProtocol? { get set}
}

final class FeedEditViewController: BaseViewController<FeedEditView> {

  // MARK: - Properties

  var interactor: FeedEditInteractorProtocol?

  var feedId: Int = 0

  // MARK: - UIs

  private lazy var backButton = UIBarButtonItem(
    image: KKDS.Image.ic_back_24_bk,
    style: .done,
    target: self,
    action: #selector(self.backButtonDidTap(_:))
  )

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func setupConfigure() {
    self.hideKeyboardWhenTappedAround()

    self.navigationItem.do {
      $0.title = "게시글 수정"
      $0.leftBarButtonItem = self.backButton
    }
    self.navigationController?.navigationBar.setDefaultAppearance()
  }

  // MARK: - Buttton Actions

  @objc func backButtonDidTap(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - FeedEdit View Protocol

extension FeedEditViewController: FeedEditViewProtocol {

}
