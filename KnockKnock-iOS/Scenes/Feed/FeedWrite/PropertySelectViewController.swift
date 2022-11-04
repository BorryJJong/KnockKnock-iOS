//
//  PropertySelectViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

import Then
import KKDSKit

protocol PropertySelectViewProtocol {
}

final class PropertySelectViewController: BaseViewController<PropertySelectView> {
  
  // MARK: - Properties
  
  let tagList = ["#거꾸로챌린지", "#용기내챌린지", "#GOGO챌린지", "#1일 1환경챌린지"]
  let promotionList = ["없음", "텀블러 할인", "사은품 증정", "용기 할인"]

  var selectedProperties: [String] = []
  var propertyType = PropertyType.promotion
  
  var router: PropertySelectRouterProtocol?

  // MARK: - UIs

  private lazy var backBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_back_24_wh,
    style: .plain,
    target: self,
    action: #selector(tapBackBarButton(_:))
  ).then {
    $0.tintColor = .black
  }

  // MARK: - Life cylce
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func setupConfigure() {
    self.navigationItem.title = "태그"

    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonDidTap(_:))
    )

    self.navigationItem.leftBarButtonItem = self.backBarButtonItem

    self.containerView.propertyTableView.do {
      $0.dataSource = self
      $0.delegate = self
    }
  }

  // MARK: - Button Actions

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    self.router?.passDataToFeedWriteView(
      source: self,
      propertyType: self.propertyType,
      selectedProperties: self.selectedProperties
    )
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.router?.navigateToFeedWriteView(source: self)
  }
}

// MARK: - PropertySelectViewProtocol

extension PropertySelectViewController: PropertySelectViewProtocol {
}

// MARK: - TableView DataSource

extension PropertySelectViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tagList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: PropertyCell.self, for: indexPath)

    switch propertyType {
    case .promotion:
      cell.bind(content: promotionList[indexPath.row])

    case .tag:
      cell.bind(content: tagList[indexPath.row])

    case .address:
      print("error")
    }

    return cell
  }
}

extension PropertySelectViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    switch propertyType {
    case .tag:
      self.selectedProperties.append(self.tagList[indexPath.item])

    case .promotion:
      self.selectedProperties.append(self.promotionList[indexPath.item])

    case .address:
      print("error")
    }
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    switch propertyType {
    case .tag:
      if let index = self.selectedProperties.firstIndex(of: self.tagList[indexPath.item]) {
        self.selectedProperties.remove(at: index)
      }

    case .promotion:
      if let index = self.selectedProperties.firstIndex(of: self.promotionList[indexPath.item]) {
        self.selectedProperties.remove(at: index)
      }

    case .address:
      print("error")
    }

  }
}
