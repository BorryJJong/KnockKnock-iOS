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

  func fetchShopAddress(address: AddressResponse)
  func fetchCountyList(county: [String])
  func fetchCityList(cityList: [String])

  func fetchSelectedCity(city: String)
  func fetchSelectedCounty(county: String)

  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class ShopSearchViewController: BaseViewController<ShopSearchView> {

  // MARK: - Properties

  var cityList: [String] = []
  var countyList: [String] = []

  var interactor: ShopSearchInteractorProtocol?
  
  var addressList: [AddressResponse.Documents] = [] {
   didSet {
      self.containerView.resultTableView.reloadData()
      self.fetchMore = true
    }
  }

  var addressResult: AddressResponse? {
    didSet {
      let isNoResult = addressResult?.meta.totalCount == 0

      self.containerView.bind(isNoResult: isNoResult)

      self.addressList += addressResult?.documents ?? []
    }
  }

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
    $0.tintColor = KKDS.Color.green50
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchCityList()
  }

  // MARK: - Configure

  override func setupConfigure() {

    self.navigationItem.do {
      $0.title = "매장검색"
      $0.rightBarButtonItem = self.rightBarButton
      $0.leftBarButtonItem = self.backBarButtonItem
    }

    self.containerView.addressTextField.do {
      $0.delegate = self
    }

    self.containerView.addressSearchButton.do {
      $0.addTarget(
        self,
        action: #selector(self.searchButtonDidTap(_:)),
        for: .touchUpInside)
    }

    self.containerView.resultTableView.do {
      $0.dataSource = self
      $0.delegate = self
    }
    
    self.containerView.cityButton.do {
      $0.addTarget(
        self,
        action: #selector(self.cityButtonDidTap(_:)),
        for: .touchUpInside
      )
    }

    self.containerView.countyButton.do {
      $0.addTarget(
        self,
        action: #selector(self.countyButtonDidTap(_:)),
        for: .touchUpInside
      )
    }

    self.hideKeyboardWhenTappedAround()
  }

  // MARK: - Button Actions

  @objc private func searchButtonDidTap(_ sender: UIButton) {
    let address = self.containerView.addressTextField.text

    self.addressList = []

    // 검색어가 비어있을 경우에 원래 상태로 복귀
    if address != "" {
      self.interactor?.fetchShopAddress(address: address, isNew: true)
    } else {
      self.containerView.setDefaultStatus()
    }

    self.dismissKeyboard()
  }

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    self.interactor?.passDataToFeedWriteView(address: nil)
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.interactor?.navigateToFeedWriteView()
  }

  @objc func cityButtonDidTap(_ sender: UIButton) {
    self.containerView.setButtonStatus(isCitySelected: false)
    self.interactor?.presentBottomSheetView(
      content: self.cityList,
      districtsType: .city
    )
  }

  @objc func countyButtonDidTap(_ sender: UIButton) {
    self.interactor?.presentBottomSheetView(
      content: self.countyList,
      districtsType: .county
    )
  }
}

// MARK: - ShopSearchView Protocol

extension ShopSearchViewController: ShopSearchViewProtocol, AlertProtocol {
  func fetchShopAddress(address: AddressResponse) {
    self.addressResult = address
  }

  func fetchCountyList(county: [String]) {
    self.countyList = county
  }

  func fetchCityList(cityList: [String]) {
    self.cityList = cityList
  }

  func fetchSelectedCity(city: String) {
    self.containerView.cityLabel.text = city
    self.containerView.setButtonStatus(isCitySelected: true)

    self.interactor?.fetchCountyList(city: city)
  }

  func fetchSelectedCounty(county: String) {
    self.containerView.countyLabel.text = county
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

extension ShopSearchViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.addressList.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(
      withType: AdressCell.self,
      for: indexPath
    )
    let selectedAddress = self.addressList[indexPath.row]

    cell.bind(
      name: selectedAddress.placeName,
      address: selectedAddress.addressName
    )

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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
          self.interactor?.fetchShopAddress(
            address: self.containerView.addressTextField.text,
            isNew: false
          )
        })
      }
    }
  }
}

// MARK: - TableView Delegate

extension ShopSearchViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    self.interactor?.passDataToFeedWriteView(
      address: self.addressList[indexPath.row]
    )
  }
}

// MARK: - TextField Delegate

extension ShopSearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.interactor?.fetchShopAddress(
      address: self.containerView.addressTextField.text,
      isNew: true
    )

    return true
  }
}
