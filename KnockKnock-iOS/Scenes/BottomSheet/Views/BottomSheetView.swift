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

    static let tableViewTopMargin = 30.f
    static let tableViewBottomMargin = 20.f
  }

  // MARK: - Properties

  var bottomSheetSize: BottomSheetSize = .medium

  let screenHeight = UIDevice.current.heightOfSafeArea(includeBottomInset: true)

  lazy var bottomSheetHeight: CGFloat = self.bottomSheetSize.rawValue * self.screenHeight
  lazy var bottomSheetMinHeight: CGFloat = self.screenHeight * BottomSheetSize.medium.rawValue
  lazy var bottomSheetPanMinTopConstant: CGFloat = self.bottomSheetHeight
  lazy var bottomSheetPanStartingTopConstant: CGFloat = self.bottomSheetPanMinTopConstant

  // MARK: - UIs

  let dimmedBackView = UIView().then {
    $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  }

  let bottomSheetView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 27
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.clipsToBounds = true
  }

  let dismissIndicatorView = UIView().then {
    $0.backgroundColor = .systemGray2
    $0.layer.cornerRadius = 3
  }

  let tableView = UITableView().then {
    $0.isScrollEnabled = false
    $0.separatorColor = .clear
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: BottomMenuCell.self)
    $0.isScrollEnabled = true
    $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: -20)
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bottom Sheet Animation

  /// values 중에서 number와 더 가까운 값을 찾아 반환하는 메소드
  private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
    guard let nearestValue = values.min(by: {abs(number - $0) < abs(number - $1)}) else {
      return number
    }
    return nearestValue
  }

  func showBottomSheet() {
    let nearestValue = nearest(
      to: self.bottomSheetHeight,
      inValues: [
        self.bottomSheetMinHeight,
        self.bottomSheetPanMinTopConstant
      ]
    )

    self.bottomSheetView.snp.updateConstraints {
      $0.top.equalToSuperview().offset(nearestValue)
    }

    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.dimmedBackView.alpha = 0.5
        self.layoutIfNeeded()
      }, completion: nil
    )
  }

  func hideBottomSheet(view: BottomSheetViewController) {
    self.bottomSheetView.snp.updateConstraints {
      $0.top.equalToSuperview().offset(self.screenHeight)
    }

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

    self.dimmedBackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.bottomSheetView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
      $0.top.equalToSuperview().offset(screenHeight)
      $0.bottom.equalToSuperview()
    }

    self.dismissIndicatorView.snp.makeConstraints {
      $0.width.equalTo(Metric.dismissIndicatorViewWidth)
      $0.height.equalTo(Metric.dismissIndicatorViewHeight)
      $0.top.equalTo(self.bottomSheetView.snp.top).offset(Metric.dismissIndicatorViewTopMargin)
      $0.centerX.equalTo(self.bottomSheetView.snp.centerX)
    }

    self.tableView.snp.makeConstraints {
      $0.top.equalTo(self.bottomSheetView.snp.top).offset(Metric.tableViewTopMargin)
      $0.leading.trailing.equalTo(self.bottomSheetView)
      $0.bottom.equalTo(self.bottomSheetView.snp.bottom).offset(Metric.tableViewBottomMargin)
    }
  }
}
