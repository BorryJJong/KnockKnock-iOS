//
//  MyViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

protocol MyViewProtocol: AnyObject {
  var interactor: MyInteractorProtocol? { get set }

  func fetchMenuData(menuData: MyMenu)
  func checkLoginStatus(isSignedIn: Bool)
  func fetchNickname(nickname: String)
}

final class MyViewController: BaseViewController<MyView> {

  // MARK: - Constants

  private enum MY {
    static let MyCellID = "MyTableCellID"
    static let APP_VERSION = "V 0.0.1"
  }

  // MARK: - Properties

  var interactor: MyInteractorProtocol?

  var selectedMenuItem: MyMenuType?

  var isSignedIn: Bool = false {
    didSet {
      if isSignedIn {
        self.interactor?.fetchNickname()
      }
      self.containerView.setSigninStatus(isSignedIn: self.isSignedIn)
      self.containerView.myTableView.reloadData()
    }
  }

  var nickname: String = "" {
    didSet {
      self.containerView.setNickname(nickname: self.nickname)
    }
  }
  
  var menuData: MyMenu = [] {
    didSet {
      self.containerView.myTableView.reloadData()
    }
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.interactor?.checkSignInStatus()
    self.tabBarController?.tabBar.isHidden = false
  }

  // MARK: - Configure
  
  override func setupConfigure() {
    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.title = "마이"

    self.containerView.setSigninStatus(isSignedIn: self.isSignedIn) // 로그인 상태에 따라 헤더 내용 바인딩
    self.containerView.setNickname(nickname: self.nickname)

    self.interactor?.fetchMenuData()

    self.containerView.myTableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.registCell(
        type: UITableViewCell.self,
        identifier: MY.MyCellID
      )
      $0.register(type: MyTableViewHeader.self)
      $0.register(type: MyTableViewFooter.self)
      
      $0.tableHeaderView = self.containerView.myTableHeaderView
    }

    self.containerView.loginButton.do {
      $0.addTarget(
        self,
        action: #selector(self.loginButtonDidTap),
        for: .touchUpInside
      )
    }
  }

  // MARK: - Button Actions

  @objc private func loginButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToLoginView(source: self)
  }

  @objc func signOutButtonDidTap(_ sender: UIButton) {
    self.interactor?.requestSignOut()
  }
}

// MARK: - My View Protocol

extension MyViewController: MyViewProtocol {

  func fetchMenuData(menuData: MyMenu) {
    self.menuData = menuData
  }

  func checkLoginStatus(isSignedIn: Bool) {
    self.isSignedIn = isSignedIn
  }

  func fetchNickname(nickname: String) {
    self.nickname = nickname
  }
}

// MARK: - TableView DataSource

extension MyViewController: UITableViewDataSource {

  // Cell

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    if section == 0 {
      if !self.isSignedIn {
        return 0
      }
    }
    return self.menuData[section].myItems.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.menuData.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {

    let cell = UITableViewCell(
      style: .value1,
      reuseIdentifier: MY.MyCellID
    )
    let menu = self.menuData[indexPath.section].myItems[indexPath.row]

    cell.selectionStyle = .none
    cell.textLabel?.do {
      $0.font = .systemFont(ofSize: 15, weight: .bold)
      $0.textColor = .black
      $0.text = menu.title.rawValue
    }

    switch menu.type {
    case .alert:
      cell.accessoryType = .none
      cell.accessoryView = UISwitch()
    case .plain:
      cell.accessoryType = .disclosureIndicator
    case .version:
      cell.detailTextLabel?.text = MY.APP_VERSION
      cell.accessoryType = .disclosureIndicator
    }

    return cell
  }

  // Header, Footer
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    
    let headerView = tableView.dequeueHeaderFooterView(withType: MyTableViewHeader.self)
    
    headerView.model = self.menuData[section]

    return headerView
  }

  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    if self.menuData[section].title == MySectionType.myInfo {
      if !isSignedIn {
        return 0
      }
    }
    return 50
  }

  func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    
    let footerView = tableView.dequeueHeaderFooterView(withType: MyTableViewFooter.self)

    footerView.signOutButton.addTarget(
      self,
      action: #selector(self.signOutButtonDidTap(_:)),
      for: .touchUpInside
    )
    
    footerView.model = self.menuData[section]
    footerView.setSignOutButtonHiddenStatus(isSignedIn: self.isSignedIn)
    
    return footerView
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    let title = self.menuData[section].title

    switch title {
    case .myInfo:
      if !self.isSignedIn {
        return 0
      }

    case .policy:
      if isSignedIn {
        return 130
      }

    default:
      return 50
    }

    return 50
  }
}

// MARK: - TableView Delegate

extension MyViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    
    let mySection = self.menuData[indexPath.section]
    let menu = mySection.myItems[indexPath.item].title

    switch menu {
    case .profile:
      self.interactor?.navigateToProfileSettingView(source: self)

    case .withdraw:
      self.showAlert(
        content: Alert.withdraw.message,
        confirmActionCompletion: {
          self.interactor?.requestWithdraw()
        }
      )

    case .versionInfo:
      self.showAlert(
        content: Alert.versionInfo.message,
        confirmActionCompletion: {
          self.dismiss(animated: false)
        }
      )

    case .notice:
      self.interactor?.navigateToNoticeView(source: self)

    default:
      print("none")
    }
  }
} 
