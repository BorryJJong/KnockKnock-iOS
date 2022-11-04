//
//  PropertySelectViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

import Then
import KKDSKit

protocol PropertySelectViewProtocol: AnyObject {
  var router: PropertySelectRouterProtocol? { get set }
  var interactor: PropertySelectInteractorProtocol? { get set }

  func fetchPromotionList(promotionList: [Promotion])
}

final class PropertySelectViewController: BaseViewController<PropertySelectView> {
  
  // MARK: - Properties
  
  let tagList: [Promotion] = []
  var promotionList: [Promotion] = []

  var selectedProperties: [Promotion] = []
  var propertyType = PropertyType.promotion
  
  var router: PropertySelectRouterProtocol?
  var interactor: PropertySelectInteractorProtocol?

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
    self.interactor?.fetchPromotionList()
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
  func fetchPromotionList(promotionList: [Promotion]) {
    self.promotionList = promotionList
    self.promotionList.insert(Promotion(id: 0, type: "없음"), at: 0)
    self.containerView.propertyTableView.reloadData()
  }
}

// MARK: - TableView DataSource

extension PropertySelectViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch propertyType {
    case .promotion:
      return self.promotionList.count

    case .tag:
      return self.tagList.count

    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: PropertyCell.self, for: indexPath)

    switch propertyType {
    case .promotion:
      cell.bind(content: promotionList[indexPath.row].type)

    case .tag:
      cell.bind(content: tagList[indexPath.row].type)

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
