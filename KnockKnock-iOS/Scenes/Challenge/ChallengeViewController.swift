//
//  ChallengeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

protocol ChallengeViewProtocol: AnyObject {
  var interactor: ChallengeInteractorProtocol? { get set }
  
  func fetchChallenges()
}

final class ChallengeViewController: BaseViewController<ChallengeView> {
  
  // MARK: Properties
  
  var interactor: ChallengeInteractorProtocol?
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchChallenge()
  }
  
  override func setupConfigure() {
    self.containerView.tableView.do {
      $0.delegate = self
      $0.dataSource = self
    }
  }
}

extension ChallengeViewController: ChallengeViewProtocol {
  func fetchChallenges() {
    self.containerView.tableView.reloadData()
  }
}

extension ChallengeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: ChallengeCell.self, for: indexPath)
    return cell
  }
}

extension ChallengeViewController: UITableViewDelegate {
  
}
