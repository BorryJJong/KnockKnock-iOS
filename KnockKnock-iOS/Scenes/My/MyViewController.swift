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

    let myInfoSection = MyItemList(section: MySection.myInfo, myItems: [profile, signout, push])
    let customerSection = MyItemList(section: MySection.customer, myItems: [notice, version])
    let policySection = MyItemList(section: MySection.policy, myItems: [service, privacy, location, openSource])

    return [myInfoSection, customerSection, policySection]
  }()

  private let sectionTitle = ["내 정보", "고객지원", "약관 및 정책"]

  private let versionInfo = "0.1.1"
  
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
      $0.register(
        MyTableViewHeader.self,
        forHeaderFooterViewReuseIdentifier: "MyTableViewHeader"
      )
      $0.register(
        MyTableViewFooter.self,
        forHeaderFooterViewReuseIdentifier: "MyTableViewFooter"
      )
    }
  }
}

// MARK: - My View Protocol

extension MyViewController: MyViewProtocol {
  
}

// MARK: - CollectionView DataSource

extension MyViewController: UITableViewDataSource {
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

  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {

    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyTableViewHeader") as! MyTableViewHeader

    headerView.bind(self.menuData[section])

      return headerView
  }

  func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {

    let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyTableViewFooter") as! MyTableViewFooter

    footerView.bind(self.menuData[section])

      return footerView
  }

  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {

    if self.menuData[section].section == MySection.policy {
      return 130

    } else {
      return 50

    }
  }
}

extension MyViewController: UITableViewDelegate {
  func tableView(
     _ tableView: UITableView,
     didSelectRowAt indexPath: IndexPath
   ) {

     let menu = self.menuData[indexPath.section]

     switch menu.section {
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
