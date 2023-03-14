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
  func setPushSetting()
  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
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

  private var isSignedIn: Bool = false
  private var nickname: String = ""
  private var menuData: MyMenu = []
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.setNotification()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
  }

  // MARK: - Configure
  
  override func setupConfigure() {
    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.title = "마이"

    self.containerView.setSigninStatus(isSignedIn: self.isSignedIn)
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

  private func setNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.checkNotificationSetting),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }

  @objc
  private func checkNotificationSetting() {
    self.setPushSetting()
  }

  // MARK: - Button Actions

  @objc
  private func loginButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToLoginView()
  }

  @objc
  func signOutButtonDidTap(_ sender: UIButton) {
    self.interactor?.requestSignOut()
  }

  @objc
  func pushSwitchDidTap(_ sender: UISwitch) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
  }
}

// MARK: - My View Protocol

extension MyViewController: MyViewProtocol, AlertProtocol {

  func fetchMenuData(menuData: MyMenu) {
    self.menuData = menuData

    DispatchQueue.main.async {
      self.containerView.myTableView.reloadData()
    }
  }

  func checkLoginStatus(isSignedIn: Bool) {
    self.isSignedIn = isSignedIn

    DispatchQueue.main.async {

      if self.isSignedIn {
        self.interactor?.fetchNickname()
      }

      self.containerView.setSigninStatus(isSignedIn: self.isSignedIn)
    }
  }

  func fetchNickname(nickname: String) {
    self.nickname = nickname

    DispatchQueue.main.async {
      self.containerView.setNickname(nickname: self.nickname)
    }
  }

  func setPushSetting() {

    let indexPath = self.isSignedIn
    ? [IndexPath(item: 2, section: 0)]
    : [IndexPath(item: 0, section: 0)]

    DispatchQueue.main.async {
      self.containerView.myTableView.reloadRows(
        at: indexPath,
        with: .none
      )
    }
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
      cell.accessoryView = UISwitch().then {
        $0.isOn = UIApplication.shared.isRegisteredForRemoteNotifications
        $0.addTarget(
          self,
          action: #selector(self.pushSwitchDidTap(_:)),
          for: .touchUpInside
        )
      }
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

    if title == .policy {
      return 130
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
      self.interactor?.navigateToProfileSettingView()

    case .withdraw:
      DispatchQueue.main.async {
        self.showAlert(
          message: AlertMessage.withdrawConfirm.rawValue,
          isCancelActive: true,
          confirmAction: {
            self.interactor?.requestWithdraw()
          }
        )
      }

    case .versionInfo:
      DispatchQueue.main.async {
        self.showAlert(
          message: AlertMessage.versionInfo.rawValue,
          confirmAction: {
            self.dismiss(animated: false)
          }
        )
      }

    case .serviceTerms,
         .privacy,
         .locationService,
         .opensource:
      self.interactor?.navigateToPolicyView(policyType: menu) 

    default:
      DispatchQueue.main.async {
        self.showAlert(message: AlertMessage.unaccessible.rawValue)
      }
    }
  }
} 
