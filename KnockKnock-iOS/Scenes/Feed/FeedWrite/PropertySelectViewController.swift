//
//  PropertySelectViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

final class PropertySelectViewController: BaseViewController<PropertySelectView> {
  
  // MARK: - Properties
  
  enum Property {
    case tag
    case promotion
  }
  
  let tagList = ["#거꾸로챌린지", "#용기내챌린지", "#GOGO챌린지", "#1일 1환경챌린지"]
  let promotionList = ["없음", "텀블러 할인", "사은품 증정", "용기 할인"]
  
  // MARK: - Life cylce
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func setupConfigure() {
    self.navigationItem.title = "태그"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap(_:)))
    self.containerView.propertyTableView.do {
      $0.dataSource = self
    }
  }

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension PropertySelectViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tagList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: PropertyCell.self, for: indexPath)
    cell.propertyLabel.text = tagList[indexPath.row]

    return cell
  }
}
