//
//  shopSearchViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

class ShopSearchViewController: BaseViewController<ShopSearchView> {

  // MARK: - Properties

  let addressDummy = ["스타벅스 오류동역점", "스타벅스 신도림점", "스타벅스 구로디지털타워점"]

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.navigationItem.title = "매장검색"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonDidTap(_:)))
    self.containerView.addressSearchButton.do {
      $0.addTarget(self, action: #selector(searchButtonDidTap(_:)), for: .touchUpInside)
    }
    self.containerView.resultTableView.do {
      $0.dataSource = self
    }
  }

  @objc private func searchButtonDidTap(_ sender: UIButton) {
    self.containerView.resultTableView.isHidden = false
  }

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

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
