//
//  PropertySelectView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

import Then

final class PropertySelectView: UIView {

  // MARK: - Properties

  enum Property {
    case tag
    case promotion
  }

  // MARK: - UI

  let tableView = UITableView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: PropertyCell.self)
  }

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupConstraints() {
    [self.tableView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
