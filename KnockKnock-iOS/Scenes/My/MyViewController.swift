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

  private let versionInfo = "0.1.1"
  private let headerContent = [ "내 정보", "고객지원", "약관 및 정책" ]
  private let titleContent = [
    ["프로필수정", "탈퇴하기", "앱 PUSH 알림"],
    ["공지사항", "버전정보"],
    ["서비스 이용약관", "개인정보 처리방침", "위치기반 서비스 이용약관", "오픈소스 라이선스"]
  ]
  
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
    
    self.containerView.settingCollectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.registCell(type: MyCell.self)
      $0.registHeaderView(type: MyHeaderCollectionReusableView.self)
      $0.registFooterView(type: MyFooterCollectionReusableView.self)
    }
  }
}

// MARK: - CollectionView DataSource

extension MyViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: MyCell.self, for: indexPath)
    
    let isSwitch = indexPath == IndexPath(item: 2, section: 0)
    let isVersion = indexPath == IndexPath(item: 1, section: 1)
    
    cell.bind(
      title: self.titleContent[indexPath.section][indexPath.item],
      isSwitch: isSwitch,
      isVersion: isVersion,
      versionInfo: versionInfo
    )
    
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.titleContent[section].count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.headerContent.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    self.navigationController?.pushViewController(NoticeViewController(), animated: true)
  }
}

extension MyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: self.containerView.frame.width, height: 30)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 15
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    if section == 2 {
      return CGSize(width: self.containerView.frame.width, height: 130)
    } else {
      return CGSize(width: self.containerView.frame.width, height: 50)
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: self.containerView.frame.width, height: 50)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: MyHeaderCollectionReusableView.self,
        for: indexPath
      )
      
      header.bind(title: self.headerContent[indexPath.section])
      
      return header
    case UICollectionView.elementKindSectionFooter:
      let footer = collectionView.dequeueReusableSupplementaryFooterView(
        withType: MyFooterCollectionReusableView.self,
        for: indexPath
      )
      
      footer.bind(isLast: indexPath.section == 2)
      
      return footer
      
    default:
      return UICollectionReusableView()
    }
  }
}
