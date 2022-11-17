//
//  PropertySelectView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

import Then
import KKDSKit
import SnapKit

final class PropertySelectView: UIView {

  // MARK: - UI

  let propertyTableView = UITableView(
    frame: .zero,
    style: .plain
  ).then {
    $0.backgroundColor = .white
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: PropertyCell.self)
    $0.allowsMultipleSelection = true
    $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    $0.separatorColor = KKDS.Color.gray30
  }

  let propertyTableHeaderView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray10
  }

  private let propertyHeaderLabel = UILabel().then {
    $0.text = "최대 5개까지 선택 가능합니다."
    $0.textColor = KKDS.Color.gray60
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.configure()
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func configure() {
    self.propertyTableHeaderView.frame = CGRect(
      x: 0,
      y: 0,
      width: self.frame.width,
      height: 50
    )
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.propertyTableView].addSubViews(self)
    [self.propertyHeaderLabel].addSubViews(self.propertyTableHeaderView)

    self.propertyHeaderLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }

    self.propertyTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
