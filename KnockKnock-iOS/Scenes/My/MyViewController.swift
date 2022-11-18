//
//  MyViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

protocol MyViewProtocol {
  
}

final class MyViewController: BaseViewController<MyView> {
  
  // MARK: - Properties
  
  var router: MyRouterProtocol?
  
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
  
  // MARK: - Configure
  
  override func setupConfigure() {
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationItem.title = "마이"
    
    self.containerView.myTableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.registCell(type: MyCell.self)
      $0.register(type: MyTableViewHeader.self)
      $0.register(type: MyTableViewFooter.self)
    }
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
    
    let cell = tableView.dequeueCell(
      withType: MyCell.self,
      for: indexPath
    )
    
    let menu = self.menuData[indexPath.section].myItems[indexPath.row]
    
    cell.model = menu
    
    if menu.type == .alert {
      cell.accessoryType = .none
    } else {
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
    
    footerView.model = self.menuData[section]
    
    return footerView
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    
    if self.menuData[section].title == MySectionType.policy {
      return 130
      
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
      print("profile")
      
    case .customer:
      if menu.myItems[indexPath.item].title == "공지사항" {
        self.router?.navigateToNoticeView(source: self)
      }
      
    case .policy:
      print("policy")
    }
    
  }
} 
