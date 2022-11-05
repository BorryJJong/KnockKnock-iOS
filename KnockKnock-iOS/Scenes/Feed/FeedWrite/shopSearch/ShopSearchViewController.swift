//
//  shopSearchViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

import KKDSKit
import Then

protocol ShopSearchViewProtocol: AnyObject {
  var interactor: ShopSearchInteractorProtocol? { get set }
  var router: ShopSearchRouterProtocol? { get set }

  func fetchShopAddress(address: AddressResult)
}

final class ShopSearchViewController: BaseViewController<ShopSearchView> {

  // MARK: - Properties

  let addressDummy = ["스타벅스 오류동역점", "스타벅스 신도림점", "스타벅스 구로디지털타워점"]

  let cityList = ["서울특별시", "부산광역시", "대구광역시", "인천광역시", "대전광역시", "울산광역시", "세종특별자치시",
                  "경기도", "강원도", "전라북도", "전라남도", "경상북도", "경상남도"]

  var interactor: ShopSearchInteractorProtocol?
  var router: ShopSearchRouterProtocol?

  var addressList: [String] = [] {
    didSet {
      self.containerView.resultTableView.reloadData()
      self.fetchMore = true
    }
  }

  var addressResult: AddressResult? {
    didSet {
      let isNoResult = addressResult?.meta.totalCount == 0
      self.containerView.bind(isNoResult: isNoResult)

      self.addressList += addressResult?.documents.map { $0.placeName } ?? []
    }
  }

  private var page: Int = 1
  private var searchKeyword = ""
  private var fetchMore = true

  // MARK: - UIs

  lazy var backBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_back_24_wh,
    style: .plain,
    target: self,
    action: #selector(tapBackBarButton(_:))
  ).then {
    $0.tintColor = .black
  }

  lazy var rightBarButton = UIBarButtonItem(
    title: "완료",
    style: .done,
    target: self,
    action: #selector(doneButtonDidTap(_:))
  ).then {
    $0.tintColor = .green50
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationItem.do {
      $0.title = "매장검색"
      $0.rightBarButtonItem = self.rightBarButton
      $0.leftBarButtonItem = self.backBarButtonItem
    }
    self.containerView.addressSearchButton.do {
      $0.addTarget(
        self,
        action: #selector(searchButtonDidTap(_:)),
        for: .touchUpInside)
    }

    self.containerView.resultTableView.do {
      $0.dataSource = self
      $0.delegate = self
    }

    self.containerView.cityTextField.do {
      $0.delegate = self
    }
    
    self.containerView.cityButton.do {
      $0.addTarget(self, action: #selector(cityButtonDidTap(_:)), for: .touchUpInside)
    }

    self.containerView.regionTextField.do {
      $0.delegate = self
    }
  }

  // MARK: - Button Actions

  @objc private func searchButtonDidTap(_ sender: UIButton) {
    self.containerView.resultTableView.isHidden = false

    let city = self.containerView.cityTextField.text ?? ""
    let region = self.containerView.regionTextField.text ?? ""
    let address = self.containerView.addressTextField.text ?? ""

    self.searchKeyword = "\(city) \(region) \(address)"

    self.addressList = []
    self.page = 1
    self.interactor?.fetchShopAddress(keyword: self.searchKeyword, page: self.page)
    self.dismissKeyboard()
  }

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    self.router?.passToFeedWriteView(source: self, address: nil)
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }

  @objc func cityButtonDidTap(_ sender: UIButton) {
    self.router?.presentBottomSheetView(source: self, content: self.cityList)
  }
}

// MARK: - ShopSearchView Protocol

extension ShopSearchViewController: ShopSearchViewProtocol {
  func fetchShopAddress(address: AddressResult) {
    self.addressResult = address
  }
}

// MARK: - TextField Delegate

extension ShopSearchViewController: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    return false
  }
}

// MARK: - TableView DataSource

extension ShopSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.addressList.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: AdressCell.self, for: indexPath)

    cell.bind(address: self.addressList[indexPath.row])

    return cell
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let height = scrollView.frame.height
    let contentSizeHeight = scrollView.contentSize.height
    let offset = scrollView.contentOffset.y
    let reachedBottom = (offset > contentSizeHeight - height)

    if reachedBottom && fetchMore {
      scrollViewDidReachBottom(scrollView)
    }
  }

  func scrollViewDidReachBottom(_ scrollView: UIScrollView) {
    if let isEnd = self.addressResult?.meta.isEnd {
      if !isEnd {
        self.fetchMore = false
        self.page += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
          self.interactor?.fetchShopAddress(
            keyword: self.searchKeyword,
            page: self.page
          )
        })
      }
    }
  }
}

// MARK: - TableView Delegate

extension ShopSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.router?.passToFeedWriteView(source: self, address: self.addressList[indexPath.row])
  }
}
