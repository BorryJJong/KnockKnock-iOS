//
//  ProfileSettingInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

import KKDSKit

protocol ProfileSettingInteractorProtocol {
  var worker: ProfileSettingWorkerProtocol? { get set }
  var presenter: ProfileSettingPresenterProtocol? { get set }
  var router: ProfileSettingRouterProtocol? { get set }
  
  var signInInfo: SignInInfo? { get set }
  
  func requestSignUp(nickname: String, image: UIImage)
  func fetchUserData()
  func requestEditProfile(nickname: String, image: UIImage?)
  
  func navigateToMyView()
  func popProfileView()
}

final class ProfileSettingInteractor: ProfileSettingInteractorProtocol {
  
  // MARK: - Properties
  
  var worker: ProfileSettingWorkerProtocol?
  var presenter: ProfileSettingPresenterProtocol?
  var router: ProfileSettingRouterProtocol?
  
  var signInInfo: SignInInfo?
  var userDetail: UserDetail?
  
  func navigateToMyView() {
    self.router?.navigateToMyView()
  }
  
  func popProfileView() {
    self.router?.popProfileView()
  }
  
  /// 기존에 설정 된 프로필 불러오기
  func fetchUserData() {
    self.worker?.fetchUserData(completionHandler: { [weak self] data in
      self?.userDetail = data
      self?.presenter?.presenUserData(userData: data)
    })
  }
  
  func requestSignUp(
    nickname: String,
    image: UIImage
  ) {
    guard let signInInfo = signInInfo else { return }
    
    let registerInfo = RegisterInfo(
      socialUuid: signInInfo.socialUuid,
      socialType: signInInfo.socialType,
      nickname: nickname,
      image: image
    )
    
    self.worker?.requestRegister(
      registerInfo: registerInfo,
      completionHandler: { [weak self] response in

        guard let isSuccess = self?.worker?.saveUserInfo(response: response) else { return }

        if isSuccess {
          self?.navigateToMyView()

        } else {
          self?.router?.showAlertView(message: "회원가입에 실패하였습니다.", completion: nil)
        }
      }
    )
  }
  
  /// 프로필 수정 이벤트
  /// 기존 nickname, image와 입력 된 nickname, image를 비교하여 변경 된 요소들만 수정 되도록 함
  /// 변경이 안된 요소는 nil 전달 되며, api 성공 여부에 따라 알림 메시지 노출
  func requestEditProfile(
    nickname: String,
    image: UIImage?
  ) {
    var newNickname: String?
    var newImage: UIImage?
    
    newNickname = nickname == self.userDetail?.nickname ? nil : nickname

    if let image = image {
      newImage = image.isEqualToImage(image: self.userDetail?.image) ? nil : image
    }
    
    self.worker?.requestEditProfile(
      nickname: newNickname,
      image: newImage,
      completionHandler: { isSuccess in

        if isSuccess {
          self.router?.showAlertView(
            message: "프로필 수정에 성공하였습니다." ,
            completion: {
              if let newNickname = newNickname {
                self.worker?.saveNickname(nickname: newNickname)
              }
              self.router?.navigateToMyView()
            }
          )
        } else {
          self.router?.showAlertView(
            message: "프로필 수정에 실패하였습니다.",
            completion: {
              self.router?.navigateToMyView()
            }
          )
        }
      }
    )
  }
}
