//
//  MyView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class MyView: UIView {

  // MARK: - UIs

  let myTableView = UITableView(
    frame: .zero,
    style: .grouped
  ).then {
    $0.isScrollEnabled = true
    $0.separatorColor = .clear
    $0.backgroundColor = .white
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: MyCell.self)
  }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.myTableView].addSubViews(self)

    self.myTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
