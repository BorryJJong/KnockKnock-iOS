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

  func fetchPromotionList(promotionList: [SelectablePromotion])
  func fetchTagList(tagList: [ChallengeTitle])
}

final class PropertySelectViewController: BaseViewController<PropertySelectView> {
  
  // MARK: - Properties
  
  var tagList: [ChallengeTitle] = []

  var promotionList: [SelectablePromotion] = []

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
  }
  
  override func setupConfigure() {
    self.navigationItem.title = "태그"

    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonDidTap(_:))
    )
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem

    switch propertyType {
    case .tag:
      self.interactor?.fetchTagList()
    case .promotion:
      self.interactor?.fetchPromotionList()
    case .address:
      print("error")
    }

    self.containerView.propertyTableView.do {
      $0.dataSource = self
      $0.delegate = self
    }
  }

  // MARK: - Button Actions

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    if self.propertyType == .promotion {
      self.router?.passPromotionToFeedWriteView(
        source: self,
        promotionList: self.promotionList
      )
    } else if self.propertyType == .tag {
      self.router?.passTagToFeedWriteView(
        source: self,
        tagList: self.tagList
      )
    }
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.router?.navigateToFeedWriteView(source: self)
  }
}

// MARK: - PropertySelectViewProtocol

extension PropertySelectViewController: PropertySelectViewProtocol {
  func fetchPromotionList(promotionList: [SelectablePromotion]) {
    self.promotionList = promotionList
    self.promotionList.insert(
      SelectablePromotion(
        promotionInfo: Promotion(
          id: 0,
          type: "없음"
        ), isSelected: false
      ), at: 0
    )
    self.containerView.propertyTableView.reloadData()
  }

  func fetchTagList(tagList: [ChallengeTitle]) {
    self.tagList = tagList
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
      cell.bind(content: promotionList[indexPath.row].promotionInfo.type)

    case .tag:
      cell.bind(content: tagList[indexPath.row].title)

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
      self.tagList[indexPath.row].isSelected.toggle()

    case .promotion:
      self.promotionList[indexPath.row].isSelected.toggle()

    case .address:
      print("error")
    }
  }
}
