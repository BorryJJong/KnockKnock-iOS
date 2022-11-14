//
//  PropertySelectView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

import Then

final class PropertySelectView: UIView {

  // MARK: - UI

  let propertyTableView = UITableView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: PropertyCell.self)
    $0.allowsMultipleSelection = true
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.propertyTableView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.propertyTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.propertyTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.propertyTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.propertyTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
