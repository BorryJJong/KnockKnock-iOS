//
//  ChallengeView.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import UIKit

import Then

final class ChallengeView: UIView {
  
  // MARK: - UI
  
  let tableView = UITableView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .lightGray
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
    [self.tableView].addSubViews(self)
    
    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
