//
//  HomeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

import Then

final class HomeViewController: UIViewController {

  // MARK: - UI
  private lazy var feedButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("피드 작성", for: .normal)
    $0.addTarget(self, action: #selector(feedButtonDidTap(_:)), for: .touchUpInside)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .lightGray
    self.view.addSubview(feedButton)
    self.feedButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.feedButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
  }

  @objc func feedButtonDidTap(_ sender: UIButton) {
    self.navigationController?.pushViewController(FeedWriteViewController(), animated: true)
  }
}
