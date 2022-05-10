//
//  ChallengeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import Foundation
import UIKit

class ChallengeDetailViewController: BaseViewController<ChallengeDetailView> {

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.setNavigationItem()
//    self.containerView.challengeCollectionView.do {
//      $0.delegate = self
//      $0.dataSource = self
//    }
  }

  func setNavigationItem() {
    let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back_24_wh"), style: .plain, target: self, action: nil)
    let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_gnb_share_24_wh"), style: .plain, target: self, action: nil)
    let homeBarBUttonItem = UIBarButtonItem(image: UIImage(named: "ic_gnb_home_24_wh"), style: .plain, target: self, action: nil)

    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = UIColor.clear

    self.navigationItem.leftBarButtonItem = backBarButtonItem
    self.navigationItem.rightBarButtonItems = [shareBarButtonItem, homeBarBUttonItem]
  }
}
