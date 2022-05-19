//
//  ChallengeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

class ChallengeDetailViewController: BaseViewController<ChallengeDetailView> {

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }

  override func setupConfigure() {
    self.setNavigationItem()
    self.containerView.contentsTableView.do {
      $0.delegate = self
      $0.dataSource = self
    }
  }

  func setNavigationItem() {
    let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back_24_wh"), style: .plain, target: self, action: #selector(tapBackBarButton(_:)))
    let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_gnb_share_24_wh"), style: .plain, target: self, action: nil)
    let homeBarBUttonItem = UIBarButtonItem(image: UIImage(named: "ic_gnb_home_24_wh"), style: .plain, target: self, action: nil)

    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = UIColor.clear

    self.navigationItem.leftBarButtonItem = backBarButtonItem
    self.navigationItem.rightBarButtonItems = [shareBarButtonItem, homeBarBUttonItem]
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension ChallengeDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: ChallengeDetailCell.self, for: indexPath)
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
}

extension ChallengeDetailViewController: UITableViewDelegate {

}
