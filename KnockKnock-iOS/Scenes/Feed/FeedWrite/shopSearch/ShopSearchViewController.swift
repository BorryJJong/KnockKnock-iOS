//
//  shopSearchViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

import KKDSKit
import Then

protocol ShopSearchViewProtocol {
  var interactor: ShopSearchInteractorProtocol? { get set }
  var router: ShopSearchRouterProtocol? { get set }
}

final class ShopSearchViewController: BaseViewController<ShopSearchView>, ShopSearchViewProtocol {

  // MARK: - Properties

  let addressDummy = ["스타벅스 오류동역점", "스타벅스 신도림점", "스타벅스 구로디지털타워점"]

  var interactor: ShopSearchInteractorProtocol?
  var router: ShopSearchRouterProtocol?

  // MARK: - UIs

  lazy var backBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_back_24_wh,
    style: .plain,
    target: self,
    action: #selector(tapBackBarButton(_:))
  ).then {
    $0.tintColor = .black
  }

  lazy var rightBarButton = UIBarButtonItem(
    title: "완료",
    style: .done,
    target: self,
    action: #selector(doneButtonDidTap(_:))
  ).then {
    $0.tintColor = .green50
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationItem.do {
      $0.title = "매장검색"
      $0.rightBarButtonItem = self.rightBarButton
      $0.leftBarButtonItem = self.backBarButtonItem
    }
    self.containerView.addressSearchButton.do {
      $0.addTarget(
        self,
        action: #selector(searchButtonDidTap(_:)),
        for: .touchUpInside)
    }

    self.containerView.resultTableView.do {
      $0.dataSource = self
    }

    self.containerView.cityTextField.do {
      $0.delegate = self
    }

    self.containerView.regionTextField.do {
      $0.delegate = self
    }
  }

  // MARK: - Button Actions

  @objc private func searchButtonDidTap(_ sender: UIButton) {
    self.containerView.resultTableView.isHidden = false
  }

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

  // MARK: - TextField Delegate

extension ShopSearchViewController: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    return false
  }
}

  // MARK: - TableView DataSource

extension ShopSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addressDummy.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: AdressCell.self, for: indexPath)
    cell.addressLabel.text = addressDummy[indexPath.row]
    return cell
  }
}
