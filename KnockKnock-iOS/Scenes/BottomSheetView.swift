//
//  BottomSheetView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

final class BottomSheetView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let dismissIndicatorViewWidth = 35.f
    static let dismissIndicatorViewHeight = 5.f
    static let dismissIndicatorViewTopMargin = 10.f

    static let tableViewTopMargin = 15.f
    static let tableViewLeadingMargin = 20.f
    static let tableViewTrailingMargin = -20.f
    static let tableViewBottomMargin = 20.f
  }

  // MARK: - Properties

  lazy var topConstant = self.safeAreaInsets.bottom + self.safeAreaLayoutGuide.layoutFrame.height
  lazy var bottomSheetViewTopConstraint: NSLayoutConstraint = self.bottomSheetView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: topConstant)

  // MARK: - UIs

  let dimmedBackView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  }

  let bottomSheetView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 27
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.clipsToBounds = true
  }

  let dismissIndicatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .systemGray2
    $0.layer.cornerRadius = 3
  }

  let tableView = UITableView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isScrollEnabled = false
    $0.separatorColor = .clear
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: BottomMenuCell.self)
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupConstraints() {
    [self.dimmedBackView, self.bottomSheetView].addSubViews(self)
    [self.dismissIndicatorView, self.tableView].addSubViews(self.bottomSheetView)

    NSLayoutConstraint.activate([
      self.dimmedBackView.topAnchor.constraint(equalTo: self.topAnchor),
      self.dimmedBackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.dimmedBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.dimmedBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      self.bottomSheetView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.bottomSheetView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.bottomSheetView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.bottomSheetViewTopConstraint,

      self.dismissIndicatorView.widthAnchor.constraint(equalToConstant: Metric.dismissIndicatorViewWidth),
      self.dismissIndicatorView.heightAnchor.constraint(equalToConstant: Metric.dismissIndicatorViewHeight),
      self.dismissIndicatorView.topAnchor.constraint(equalTo: self.bottomSheetView.topAnchor, constant: Metric.dismissIndicatorViewTopMargin),
      self.dismissIndicatorView.centerXAnchor.constraint(equalTo: self.bottomSheetView.centerXAnchor),

      self.tableView.topAnchor.constraint(equalTo: self.bottomSheetView.topAnchor, constant: Metric.tableViewTopMargin),
      self.tableView.leadingAnchor.constraint(equalTo: self.bottomSheetView.leadingAnchor, constant: Metric.tableViewLeadingMargin),
      self.tableView.trailingAnchor.constraint(equalTo: self.bottomSheetView.trailingAnchor, constant: Metric.tableViewTrailingMargin),
      self.tableView.bottomAnchor.constraint(equalTo: self.bottomSheetView.bottomAnchor, constant: Metric.tableViewBottomMargin)
    ])
  }
}
