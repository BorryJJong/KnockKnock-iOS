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

    self.containerView.countyTextField.do {
      $0.delegate = self
    }
  }

  // MARK: - Button Actions

  @objc private func searchButtonDidTap(_ sender: UIButton) {
    self.containerView.resultTableView.isHidden = false

    let city = self.containerView.cityTextField.text ?? ""
    let region = self.containerView.countyTextField.text ?? ""
    let address = self.containerView.addressTextField.text ?? ""

    let keyword = "\(city) \(region) \(address)"

    self.interactor?.fetchShopAddress(keyword: keyword)
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
//
//  @objc func countyButtonDidTap(_ sender: UIButton) {
//    self.router?.presentBottomSheetView(source: self, content: self.countyList)
//  }
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
      
      self.router?.passToFeedWriteView(source: self, address: address)
    }
  }
}
