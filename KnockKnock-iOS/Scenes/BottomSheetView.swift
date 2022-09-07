//
//  BottomSheetView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then
import SnapKit

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

  let screenHeight = UIDevice.current.heightOfSafeArea()
  lazy var topConstant = self.safeAreaInsets.bottom + self.screenHeight
  lazy var bottomSheetViewTopConstraint: NSLayoutConstraint = self.bottomSheetView.topAnchor.constraint(
    equalTo: self.safeAreaLayoutGuide.topAnchor,
    constant: topConstant
  )

  let bottomHeight: CGFloat = 150

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

  let alertView = AlertView().then {
    $0.isHidden = true
    $0.bind(content: "댓글을 삭제하시겠습니까?", isCancelActive: true)
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Alert view 노출/숨김 처리

  func setHiddenStatusAlertView(isHidden: Bool) {
    self.alertView.isHidden = isHidden
  }

  // MARK: - Bottom Sheet Animation

  func showBottomSheet() {
    let safeAreaHeight: CGFloat = self.safeAreaLayoutGuide.layoutFrame.height
    let bottomPadding: CGFloat = self.safeAreaInsets.bottom

    self.bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - self.bottomHeight

    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
      self.dimmedBackView.alpha = 0.5
      self.layoutIfNeeded()
    }, completion: nil)
  }

  func hideBottomSheet(view: BottomSheetViewController) {
    let safeAreaHeight = self.safeAreaLayoutGuide.layoutFrame.height
    let bottomPadding = self.safeAreaInsets.bottom

    self.bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
      self.dimmedBackView.alpha = 0.0
      self.layoutIfNeeded()
    }) { _ in
      if view.presentingViewController != nil {
        view.dismiss(animated: false, completion: nil)
      }
    }
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.dimmedBackView, self.bottomSheetView].addSubViews(self)
    [self.dismissIndicatorView, self.tableView].addSubViews(self.bottomSheetView)
    [self.alertView].addSubViews(self)

    self.alertView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    NSLayoutConstraint.activate([
      self.dimmedBackView.topAnchor.constraint(equalTo: self.topAnchor),
      self.dimmedBackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.dimmedBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.dimmedBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      self.bottomSheetView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.bottomSheetView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.bottomSheetView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      bottomSheetViewTopConstraint,

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
