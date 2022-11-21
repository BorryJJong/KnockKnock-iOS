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
  }

  lazy var myTableHeaderView = UIView(
    frame: CGRect(
      x: 0,
      y: 0,
      width: self.frame.size.width,
      height: 50
    )
  )

  let loginButton = UIButton().then {
    $0.setTitle("녹녹 회원이 되어보세요 🌿 ", for: .normal)
    $0.setImage(KKDS.Image.ic_left_10_gr, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    $0.setTitleColor(KKDS.Color.green50, for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
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
    [self.loginButton].addSubViews(self.myTableHeaderView)
    
    self.myTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.loginButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
