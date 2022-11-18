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
  func fetchCountyList(county: [String])
  func fetchCityList(cityList: [String])

  func fetchSelectedCity(city: String)
  func fetchSelectedCounty(county: String)
}

final class ShopSearchViewController: BaseViewController<ShopSearchView> {

  // MARK: - Properties

  var cityList: [String] = []
  var countyList: [String] = []

  var interactor: ShopSearchInteractorProtocol?
  var router: ShopSearchRouterProtocol?

  var addressResult: AddressResult? {
    didSet {
      let isNoResult = addressResult?.meta.totalCount == 0
      self.containerView.bind(isNoResult: isNoResult)
      self.containerView.resultTableView.reloadData()
    }
  }

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
    self.interactor?.fetchCityList()
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
  }

  // MARK: - Button Actions

  @objc private func searchButtonDidTap(_ sender: UIButton) {
    self.containerView.resultTableView.isHidden = false

    let city = self.containerView.cityLabel.text ?? ""
    let region = self.containerView.countyLabel.text ?? ""
    let address = self.containerView.addressTextField.text ?? ""

    let keyword = "\(city) \(region) \(address)"

    self.interactor?.fetchShopAddress(keyword: keyword)
  }

  @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
    self.router?.passDataToFeedWriteView(source: self, address: nil)
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.router?.navigateToFeedWriteView(source: self)
  }

  @objc func cityButtonDidTap(_ sender: UIButton) {
    self.router?.presentBottomSheetView(
      source: self,
      content: self.cityList,
      districtsType: .city
    )
  }

  @objc func countyButtonDidTap(_ sender: UIButton) {
    self.router?.presentBottomSheetView(
      source: self,
      content: self.countyList,
      districtsType: .county
    )
  }
}

// MARK: - ShopSearchView Protocol

extension ShopSearchViewController: ShopSearchViewProtocol {
  func fetchShopAddress(address: AddressResult) {
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
}

// MARK: - TableView DataSource

extension ShopSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.addressResult?.documents.count ?? 0
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: AdressCell.self, for: indexPath)

    if let address = self.addressResult?.documents[indexPath.row].placeName {
      cell.bind(address: address)
    }
    
    return cell
  }
}

// MARK: - TableView Delegate

extension ShopSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let address = self.addressResult?.documents[indexPath.row].placeName {
      self.router?.passDataToFeedWriteView(source: self, address: address)
    }
  }
}
