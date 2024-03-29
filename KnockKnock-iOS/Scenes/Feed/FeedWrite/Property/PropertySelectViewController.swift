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
  var interactor: PropertySelectInteractorProtocol? { get set }

  func fetchPromotionList(promotionList: [Promotion])
  func fetchTagList(tagList: [ChallengeTitle])

  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class PropertySelectViewController: BaseViewController<PropertySelectView> {
  
  // MARK: - Properties
  
  var tagList: [ChallengeTitle] = []
  var promotionList: [Promotion] = []

  var propertyType = PropertyType.promotion

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
    switch self.propertyType {
    case .tag:
      self.navigationItem.title = "태그"

    case .promotion:
      self.navigationItem.title = "프로모션"

    case .address:
      self.navigationItem.title = "매장검색"

    }

    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "완료",
      style: .done,
      target: self,
      action: #selector(self.doneButtonDidTap(_:))
    ).then {
      $0.tintColor = KKDS.Color.green50
    }

    self.navigationItem.leftBarButtonItem = self.backBarButtonItem

    switch propertyType {
    case .tag:
      if self.tagList.isEmpty {
        self.interactor?.fetchTagList()
      }

    case .promotion:
      if self.promotionList.isEmpty {
        self.interactor?.fetchPromotionList()
      }

    case .address:
      print("error")
    }

    self.containerView.propertyTableView.do {
      $0.dataSource = self
      $0.delegate = self
      
      if self.propertyType == .tag {
        $0.tableHeaderView = self.containerView.propertyTableHeaderView
      } else {
        $0.tableHeaderView = UIView()
      }
    }
  }

  // MARK: - Button Actions

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {

    if self.propertyType == .promotion {

      self.interactor?.passPromotionToFeedWriteView(promotionList: self.promotionList)

    } else if self.propertyType == .tag {

      self.interactor?.passTagToFeedWriteView(tagList: self.tagList)

    }
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.interactor?.navigateToFeedWriteView()
  }
}

// MARK: - PropertySelectViewProtocol

extension PropertySelectViewController: PropertySelectViewProtocol, AlertProtocol {
  func fetchPromotionList(promotionList: [Promotion]) {
    self.promotionList = promotionList
    self.promotionList.insert(
      Promotion(
        id: 0,
        type: "없음",
        isSelected: false
      ), at: 0
    )
    self.containerView.propertyTableView.reloadData()
  }

  func fetchTagList(tagList: [ChallengeTitle]) {
    self.tagList = tagList
    self.tagList.remove(at: 0)
    self.containerView.propertyTableView.reloadData()
  }

  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async {
      self.showAlert(
        message: message,
        isCancelActive: isCancelActive,
        confirmAction: confirmAction
      )
    }
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
      let promotion = promotionList[indexPath.row]

      cell.bind(content: promotion.type, isSelected: promotion.isSelected)

    case .tag:
      let tag = tagList[indexPath.row]
      cell.bind(content: tag.title, isSelected: tag.isSelected)

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

      let selectionCount = self.tagList.filter { $0.isSelected == true }.count

      if selectionCount > 5 {
        self.tagList[indexPath.row].isSelected.toggle()
      }
      tableView.reloadRows(at: [indexPath], with: .none)

    case .promotion:

      if self.promotionList[0].isSelected && indexPath.row != 0 {
        self.promotionList[0].isSelected = false
      } else if !self.promotionList[0].isSelected && indexPath.row == 0 {
        for index in 1 ..< promotionList.count {
          promotionList[index].isSelected = false
        }
      }
      self.promotionList[indexPath.row].isSelected.toggle()

      tableView.reloadData()

    case .address:
      print("error")

    }
  }
}
