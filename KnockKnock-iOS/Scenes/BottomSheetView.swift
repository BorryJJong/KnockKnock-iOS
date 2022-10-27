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

  var bottomSheetType: BottomSheetType = .medium

  let screenHeight = UIDevice.current.heightOfSafeArea()
  lazy var topConstant = self.safeAreaInsets.bottom + self.screenHeight

  lazy var bottomHeight: CGFloat = bottomSheetType.rawValue * screenHeight

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

    self.bottomSheetView.snp.updateConstraints {
      $0.top.equalTo((safeAreaHeight + bottomPadding) - self.bottomHeight)
        print(safeAreaHeight)
            print( bottomPadding)
              print(self.bottomHeight)
    }

    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
      self.dimmedBackView.alpha = 0.5
      self.layoutIfNeeded()
    }, completion: nil)
  }

  func hideBottomSheet(view: BottomSheetViewController) {
    let safeAreaHeight = self.safeAreaLayoutGuide.layoutFrame.height
    let bottomPadding = self.safeAreaInsets.bottom

    self.bottomSheetView.snp.updateConstraints {
      $0.top.equalToSuperview().offset(safeAreaHeight + bottomPadding)
    }
//    self.bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
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

    self.dimmedBackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.bottomSheetView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
      $0.top.equalToSuperview().offset(topConstant)
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
      $0.leading.equalTo(self.bottomSheetView.snp.leading).offset(Metric.tableViewLeadingMargin)
      $0.trailing.equalTo(self.bottomSheetView.snp.trailing).offset(Metric.tableViewTrailingMargin)
      $0.bottom.equalTo(self.bottomSheetView.snp.bottom).offset(Metric.tableViewBottomMargin)
    }
  }
}
