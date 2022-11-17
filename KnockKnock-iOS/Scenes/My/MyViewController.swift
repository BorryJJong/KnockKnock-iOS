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

  private let menuData: [MyItemList] = {
    let profile = MyItem(title: "프로필 수정", type: .plain)
    let signout = MyItem(title: "탈퇴하기", type: .plain)
    let push = MyItem(title: "앱 PUSH 알림", type: .alert)

    let notice = MyItem(title: "공지사항", type: .plain)
    let version = MyItem(title: "버전정보", type: .version)

    let service = MyItem(title: "서비스 이용약관", type: .plain)
    let privacy = MyItem(title: "개인정보 처리방침", type: .plain)
    let location = MyItem(title: "위치기반 서비스 이용약관", type: .plain)
    let openSource = MyItem(title: "오픈소스 라이선스", type: .plain)

    let myInfoSection = [profile, signout, push]
    let customerSection = [notice, version]
    let policySection = [service, privacy, location, openSource]

    return [myInfoSection, customerSection, policySection]
  }()

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
    }
  }
}

// MARK: - My View Protocol

extension MyViewController: MyViewProtocol {
  
}

// MARK: - CollectionView DataSource

extension MyViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuData[section].count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return self.menuData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: MyCell.self, for: indexPath)

    cell.model = self.menuData[indexPath.section][indexPath.row]

    return cell
  }
}

extension MyViewController: UITableViewDelegate {

} 
