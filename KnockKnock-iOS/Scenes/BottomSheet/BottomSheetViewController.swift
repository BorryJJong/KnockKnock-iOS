//
//  BottomSheetViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon

protocol BottomSheetViewProtocol: AnyObject {
}

final class BottomSheetViewController: BaseViewController<BottomSheetView> {
  
  // MARK: - Properties
  
  private var options: [String] = []
  var districtsType: DistrictsType?
  
  var router: BottomSheetRouterProtocol?
  var deleteAction: (() -> Void)?
  var feedData: FeedList.Post?
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.setupGestureRecognizer()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.containerView.showBottomSheet()
  }
  
  // MARK: - Configure
  
  override func setupConfigure() {
    self.view.backgroundColor = .clear
    self.containerView.tableView.do {
      $0.dataSource = self
      $0.delegate = self
    }
    self.containerView.dimmedBackView.alpha = 0.0
  }
  
  // MARK: - Bind

  func setBottomSheetContents(
    contents: [String],
    bottomSheetType: BottomSheetType
  ) {
    self.options = contents
    self.containerView.bottomSheetType = bottomSheetType
  }
  
  // MARK: - Gesture
  
  private func setupGestureRecognizer() {
    let dimmedTap = UITapGestureRecognizer(
      target: self,
      action: #selector(dimmedViewTapped(_:))
    )
    self.containerView.dimmedBackView.addGestureRecognizer(dimmedTap)
    self.containerView.dimmedBackView.isUserInteractionEnabled = true

    let gesture = UIPanGestureRecognizer(
      target: self,
      action: #selector(self.panGesture(_:))
    )
    gesture.delaysTouchesBegan = false
    gesture.delaysTouchesEnded = false

    self.containerView.bottomSheetView.addGestureRecognizer(gesture)
  }
  
  @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
    self.containerView.hideBottomSheet(view: self)
  }

  @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
    let translationY = recognizer.translation(in: self.containerView).y

    let velocity = recognizer.velocity(in: self.containerView)

    switch recognizer.state {

    case .began:
      self.containerView.bottomSheetPanStartingTopConstant = self.containerView.bottomSheetHeight

    case .changed:
      let movePostion = self.containerView.bottomSheetPanStartingTopConstant + translationY

      if self.containerView.bottomSheetMinHeight > movePostion &&
          movePostion > self.containerView.bottomSheetPanMinTopConstant {
        self.containerView.bottomSheetHeight = self.containerView.bottomSheetPanStartingTopConstant + translationY

        self.containerView.bottomSheetView.snp.updateConstraints {
          $0.top.equalToSuperview().offset(self.containerView.bottomSheetHeight)
        }
      }

    case .ended:
      self.containerView.showBottomSheet()

      if velocity.y > 1500 {
        self.containerView.hideBottomSheet(view: self)
        return
      }

    default:
      break

    }
  }
}

// MARK: - Bottom Sheet View Protocol

extension BottomSheetViewController: BottomSheetViewProtocol {
  
}

// MARK: - TableView DataSource

extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.options.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(
      withType: BottomMenuCell.self,
      for: indexPath
    )
    cell.setData(labelText: options[indexPath.row])
    cell.setSelected(true, animated: false)
    
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    if let districtsType = self.districtsType {
      switch districtsType {
      case .city:
        self.router?.passCityDataToShopSearch(
          source: self,
          city: options[indexPath.row]
        )
      case .county:
        self.router?.passCountyDataToShopSearch(
          source: self,
          county: options[indexPath.row]
        )
      }
    } else {
      
      let option = BottomSheetOption(rawValue: options[indexPath.row])
      
      switch option {
      case .postDelete:
        self.showAlert(
          content: "게시글을 삭제하시겠습니까?",
          confirmActionCompletion: {
            self.dismiss(animated: true, completion: self.deleteAction)
          }
        )
        
      case .postEdit:
        self.containerView.hideBottomSheet(view: self)
        
        // 추후 케이스 별 코드 작성 필요

      case .postShare:

        guard let data = self.feedData,
              let postImage = data.blogImages.first,
              let likeCount = Int(data.blogLikeCount.filter { $0.isNumber }),
              let commentCount = Int(data.blogCommentCount.filter { $0.isNumber })
        else { return }

        // 추후에 worker로 빼기
        if ShareApi.isKakaoTalkSharingAvailable(){

          let appLink = Link(iosExecutionParams: ["feedDetail": "\(data.id)"])

          let button = Button(title: "앱에서 보기", link: appLink)

          let content = Content(title: "\(data.userName)님의 게시물",
                                imageUrl: URL(string: postImage.fileUrl)!,
                                description: data.content,
                                link: appLink)

          let social = Social(likeCount: likeCount,
                              commentCount: commentCount)

          let template = FeedTemplate(content: content, social: social, buttons: [button])

          if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {

            if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
              ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
                if let error = error {
                  print("error : \(error)")
                } else {
                  print("defaultLink(templateObject:templateJsonObject) success.")
                  guard let linkResult = linkResult else { return }
                  UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                }
              }
            }
          }
        } else {
          // 카카오톡 미설치: 웹 공유 사용 권장
          self.showAlert(content: "카카오톡 미설치 디바이스")
        }

      default:
        print("Error")
      }
    }
  }
}
