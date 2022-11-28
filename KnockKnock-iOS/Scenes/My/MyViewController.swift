//
//  MyViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

protocol MyViewProtocol {
  var interactor: MyInteractorProtocol? { get set }
}

final class MyViewController: BaseViewController<MyView> {

  // MARK: - Constants

  private enum MY {
    static let MyCellID = "MyTableCellID"
    static let APP_VERSION = "V 0.0.1"
  }

  // MARK: - Properties

  var interactor: MyInteractorProtocol?

  var isLoggedIn: Bool = LocalDataManager().checkTokenIsExisted() {
    didSet {
      self.containerView.myTableView.reloadData()
      self.containerView.bind(isLoggedin: self.isLoggedIn)
    }
  }
  
  private let menuData: MyMenu = {
    let profile = MyItem(title: "프로필 수정", type: .plain)
    let signout = MyItem(title: "탈퇴하기", type: .plain)
    let push = MyItem(title: "앱 PUSH 알림", type: .alert)
    
    let notice = MyItem(title: "공지사항", type: .plain)
    let version = MyItem(title: "버전정보", type: .version)
    
    let service = MyItem(title: "서비스 이용약관", type: .plain)
    let privacy = MyItem(title: "개인정보 처리방침", type: .plain)
    let location = MyItem(title: "위치기반 서비스 이용약관", type: .plain)
    let openSource = MyItem(title: "오픈소스 라이선스", type: .plain)
    
    let myInfoSection = MySection(
      title: MySectionType.myInfo,
      myItems: [profile, signout, push]
    )
    let customerSection = MySection(
      title: MySectionType.customer,
      myItems: [notice, version]
    )
    let policySection = MySection(
      title: MySectionType.policy,
      myItems: [service, privacy, location, openSource]
    )
    
    return [myInfoSection, customerSection, policySection]
  }()
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
  }

  // MARK: - Configure
  
  override func setupConfigure() {
    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.title = "마이"

    self.containerView.bind(isLoggedin: self.isLoggedIn) // 로그인 상태에 따라 헤더 내용 바인딩
    
    self.containerView.myTableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.registCell(type: UITableViewCell.self, identifier: MY.MyCellID)
      $0.register(type: MyTableViewHeader.self)
      $0.register(type: MyTableViewFooter.self)
      $0.tableHeaderView = self.containerView.myTableHeaderView
    }

    self.containerView.loginButton.do {
      $0.addTarget(self, action: #selector(self.loginButtonDidTap), for: .touchUpInside)
    }

    NotificationCenter.default.addObserver(
      forName: Notification.Name("loginCompleted"),
      object: nil,
      queue: nil
    ) { _ in
      self.isLoggedIn = true
    }

    NotificationCenter.default.addObserver(
      forName: Notification.Name("logoutCompleted"),
      object: nil,
      queue: nil
    ) { _ in
      self.isLoggedIn = false
    }
  }

  // MARK: - Button Actions

  @objc private func loginButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToLoginView(source: self)
  }

  // 테스트용 임시 로그아웃 기능 연결
  @objc func logoutButtonDidTap(_ sender: UIButton) {
    LocalDataManager().deleteToken()
    NotificationCenter.default.post(name: Notification.Name("logoutCompleted"), object: nil)
  }
}

// MARK: - My View Protocol

extension MyViewController: MyViewProtocol {
  
}

// MARK: - TableView DataSource

extension MyViewController: UITableViewDataSource {

  // Cell

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.menuData[section].myItems.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.menuData.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {

    let cell = UITableViewCell(style: .value1, reuseIdentifier: MY.MyCellID)
    let menu = self.menuData[indexPath.section].myItems[indexPath.row]

    cell.selectionStyle = .none
    cell.textLabel?.do {
      $0.font = .systemFont(ofSize: 15, weight: .bold)
      $0.textColor = .black
      $0.text = menu.title
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
    viewForFooterInSection section: Int
  ) -> UIView? {
    
    let footerView = tableView.dequeueHeaderFooterView(withType: MyTableViewFooter.self)

    footerView.logoutButton.addTarget(
      self,
      action: #selector(self.logoutButtonDidTap(_:)),
      for: .touchUpInside
    )
    
    footerView.model = self.menuData[section]
    footerView.setLogoutButtonHiddenStatus(isLoggedIn: self.isLoggedIn)
    
    return footerView
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    
    if self.menuData[section].title == MySectionType.policy {
      if isLoggedIn {
        return 130
      } else {
        return 50
      }
      
    } else {
      return 50
      
    }
  }
}

// MARK: - TableView Delegate

extension MyViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    
    let menu = self.menuData[indexPath.section]
    
    switch menu.title {
    case .myInfo:
      if menu.myItems[indexPath.item].title == "프로필 수정" {
        self.interactor?.navigateToProfileSettingView(source: self)
      }
      
    case .customer:
      if menu.myItems[indexPath.item].title == "공지사항" {
        self.interactor?.navigateToNoticeView(source: self)
      }
      
    case .policy:
      print("policy")
    }
    
  }
} 
