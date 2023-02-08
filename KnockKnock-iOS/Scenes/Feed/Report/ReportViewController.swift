//
//  ReportViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/06.
//

import UIKit
import KKDSKit

final class ReportViewController: BaseViewController<ReportView> {

  // MARK: - Properties

  private var reportTypeList: [Report] = [
    Report(
      reportType: .inappropriateContent,
      isSelected: false
    ),
    Report(
      reportType: .unauthorizeUse,
      isSelected: false
    ),
    Report(
      reportType: .personalInfoExtrusion,
      isSelected: false
    )
  ]

  private lazy var dismissBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_close_24_bk,
    style: .plain,
    target: self,
    action: #selector(self.dismissBarButtonDidTap(_:))
  ).then {
    $0.tintColor = .black
  }

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationItem.do {
      $0.title = "신고하기"
      $0.leftBarButtonItem = self.dismissBarButtonItem
    }

    self.containerView.reportTableView.do {
      $0.delegate = self
      $0.dataSource = self
    }
  }

  // MARK: - Button Actions

  @objc func dismissBarButtonDidTap(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true)
  }
}

// MARK: - TableView DataSource

extension ReportViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return ReportType.allCases.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: ReportCell.self)

    cell.bind(self.reportTypeList[indexPath.item])

    return cell
  }

}

// MARK: - TableView Delegate

extension ReportViewController: UITableViewDelegate {

  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {

    for index in 0..<reportTypeList.count {

      if index == indexPath.item {
        self.reportTypeList[index].isSelected = true

      } else {
        self.reportTypeList[index].isSelected = false
      }
    }

    tableView.reloadData()
  }

  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {

    return 60
  }

  func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {

    let footerView = tableView.dequeueHeaderFooterView(
      withType: ReportTableFooterView.self
    )

    return footerView
  }
}
