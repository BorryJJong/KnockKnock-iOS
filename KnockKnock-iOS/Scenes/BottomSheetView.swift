//
//  BottomSheetView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

final class BottomSheetView: UIView {

  // bottomSheet가 view의 상단에서 떨어진 거리
  var bottomSheetViewTopConstraint: NSLayoutConstraint!

  // 기존 화면을 흐려지게 만들기 위한 뷰
  let dimmedBackView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  }

  // 바텀 시트 뷰
  let bottomSheetView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 27
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.clipsToBounds = true
  }

  // dismiss Indicator View UI 구성 부분
  let dismissIndicatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .systemGray2
    $0.layer.cornerRadius = 3
  }

  let tableView = UITableView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isScrollEnabled = false
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

    let topConstant = self.safeAreaInsets.bottom + self.safeAreaLayoutGuide.layoutFrame.height
    self.bottomSheetViewTopConstraint = self.bottomSheetView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: topConstant)

    NSLayoutConstraint.activate([
      self.dimmedBackView.topAnchor.constraint(equalTo: self.topAnchor),
      self.dimmedBackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.dimmedBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.dimmedBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      self.bottomSheetView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.bottomSheetView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.bottomSheetView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.bottomSheetViewTopConstraint,

      self.dismissIndicatorView.widthAnchor.constraint(equalToConstant: 35),
      self.dismissIndicatorView.heightAnchor.constraint(equalToConstant: 5),
      self.dismissIndicatorView.topAnchor.constraint(equalTo: self.bottomSheetView.topAnchor, constant: 10),
      self.dismissIndicatorView.centerXAnchor.constraint(equalTo: self.bottomSheetView.centerXAnchor),

      self.tableView.topAnchor.constraint(equalTo: self.bottomSheetView.topAnchor, constant: 15),
      self.tableView.leadingAnchor.constraint(equalTo: self.bottomSheetView.leadingAnchor, constant: 20),
      self.tableView.trailingAnchor.constraint(equalTo: self.bottomSheetView.trailingAnchor, constant: -20),
      self.tableView.bottomAnchor.constraint(equalTo: self.bottomSheetView.bottomAnchor, constant: 20)
    ])
  }
}
