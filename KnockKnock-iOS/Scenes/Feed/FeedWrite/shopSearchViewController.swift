//
//  shopSearchViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

class shopSearchViewController: BaseViewController<shopSearchView> {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.navigationItem.title = "매장검색"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap(_:)))
  }

  @objc func doneButtonDidTap(_ sender: UIBarButtonItem){
    self.navigationController?.popViewController(animated: true)
  }
}
