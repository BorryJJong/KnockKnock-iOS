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
  
  var newNickname: String?
  var newImage: UIImage?
  
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
      self?.presenter?.presentUserData(userData: data)
    })
  }
  
  /// 회원가입 요청 이벤트
  ///
  /// - Parameters:
  /// - nickname: 닉네임
  /// - image: 프로필 이미지
  func requestSignUp(
    nickname: String,
    image: UIImage
  ) {
    LoadingIndicator.showLoading()
    
    // 로그인 정보 유무 확인
    guard let signInInfo = signInInfo else { return }
    
    let registerInfo = RegisterInfo(
      socialUuid: signInInfo.socialUuid,
      socialType: signInInfo.socialType,
      nickname: nickname,
      image: image.resize(newWidth: 100)
    )
    
    // 닉네임 중복 검사
    self.worker?.checkDuplicateNickname(
      nickname: nickname,
      completionHandler: { isDuplicated in
        
        if isDuplicated {
          self.router?.showAlertView(
            message: "이미 사용되고 있는 닉네임입니다.",
            completion: nil
          )
          
        } else {
          
          self.worker?.requestRegister(
            registerInfo: registerInfo,
            completionHandler: { [weak self] response in
              
              guard let isSuccess = self?.worker?.saveUserInfo(response: response) else { return }
              
              if isSuccess {
                self?.router?.showAlertView(message: "회원가입에 성공하였습니다.", completion: {
                  self?.navigateToMyView()
                })
                
              } else {
                self?.router?.showAlertView(message: "회원가입에 실패하였습니다.", completion: nil)
              }
            }
          )
        }
      }
    )
  }
  
  /// 프로필 수정 이벤트
  /// 기존에 설정 된 nickname, image와 입력 된 nickname, image를 비교하여 변경 된 요소들만 수정 되도록 함
  /// 변경이 안된 요소는 nil 전달 되며, api 성공 여부에 따라 알림 메시지 노출
  ///
  /// - Parameters:
  /// - nickname: 닉네임
  /// - image: 프로필 이미지
  func requestEditProfile(
    nickname: String,
    image: UIImage?
  ) {
    
    LoadingIndicator.showLoading()
    // 수정 될 값이 없으면 my view로 이동
    guard self.isChangedUserData(
      nickname: nickname,
      image: image
    ) == true else { return }
    
    // 닉네임 중복검사
    self.worker?.checkDuplicateNickname(
      nickname: nickname,
      completionHandler: { isDuplicated in
        
        // 본인이 사용하고 있는 닉네임이 아니고,
        // 중복 검사 결과 true일 경우 이미 사용 중인 닉네임 noti
        if nickname != self.userDetail?.nickname,
           isDuplicated {
          
          self.router?.showAlertView(
            message: "이미 사용되고 있는 닉네임입니다.",
            completion: nil
          )
          
        } else {
          
          // 프로필 수정 api 호출
          self.worker?.requestEditProfile(
            nickname: self.newNickname,
            image: self.newImage,
            completionHandler: { isSuccess, message in
              self.router?.showAlertView(
                message: message ,
                completion: {
                  self.router?.navigateToMyView()
                }
              )
            }
          )
        }
      }
    )
  }
}

// MARK: - Inner Actions

extension ProfileSettingInteractor {
  
  /// nickname, image 중 하나라도 수정 되었는지 판별
  private func isChangedUserData(
    nickname: String,
    image: UIImage?
  ) -> Bool {
    
    self.newNickname = nickname == self.userDetail?.nickname ? nil : nickname
    
    if let image = image {
      self.newImage = image.isEqualToImage(image: self.userDetail?.image) ? nil : image.resize(newWidth: 100)
    }
    
    if self.newImage == nil,
       self.newNickname == nil {
      
      self.navigateToMyView()
      return false
    }
    
    return true
  }
}
