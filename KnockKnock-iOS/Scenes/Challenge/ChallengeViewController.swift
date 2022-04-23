//
//  ChallengeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

protocol ChallengeViewProtocol: AnyObject {
  var interactor: ChallengeInteractorProtocol? { get set }
  
  func fetchChallenges(challenges: [Challenge])
}

final class ChallengeViewController: BaseViewController<ChallengeView> {
  
  // MARK: Properties
  
  var interactor: ChallengeInteractorProtocol?
  var challenges: [Challenge] = []
  
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
  func fetchChallenges(challenges: [Challenge]) {
    self.challenges = challenges
    self.containerView.tableView.reloadData()
  }
}

extension ChallengeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.challenges.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: ChallengeCell.self, for: indexPath)
    let challenge = self.challenges[indexPath.row]
    cell.bind(data: challenge)
    return cell
  }
}

extension ChallengeViewController: UITableViewDelegate {
  
}
