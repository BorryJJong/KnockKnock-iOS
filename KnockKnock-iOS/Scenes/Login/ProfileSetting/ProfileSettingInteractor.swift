//
//  ProfileSettingInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import Foundation

protocol ProfileSettingInteractorProtocol {
  var worker: ProfileSettingWorkerProtocol? { get set }
  var presenter: ProfileSettingPresenterProtocol? { get set }
  var router: ProfileSettingRouterProtocol? { get set }
  
  var signInInfo: SignInInfo? { get set }
  
  func requestSignUp(
    nickname: String,
    image: Data?
  )
  func fetchUserData()
  func requestEditProfile(
    nickname: String,
    image: Data?
  )
  
  func navigateToMyView()
  func popProfileView()
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class ProfileSettingInteractor: ProfileSettingInteractorProtocol {
  
  // MARK: - Properties
  
  var worker: ProfileSettingWorkerProtocol?
  var presenter: ProfileSettingPresenterProtocol?
  var router: ProfileSettingRouterProtocol?
  
  var signInInfo: SignInInfo?
  var userDetail: UserDetail?

  // MARK: - Routing

  func navigateToMyView() {
    self.router?.navigateToMyView()
  }
  
  func popProfileView() {
    self.router?.popProfileView()
  }

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    self.presentAlert(
      message: message,
      confirmAction: confirmAction
    )
  }

  // MARK: - Buisiness Logic

  /// 기존에 설정 된 프로필 불러오기
  func fetchUserData() {

    Task {
      let response = await self.worker?.fetchUserData()

      self.showErrorAlert(response: response)

      guard let userDetail = response?.data else { return }

      self.userDetail = userDetail
      self.presenter?.presentUserData(userData: userDetail)
    }
  }
  
  /// 회원가입 요청 이벤트
  ///
  /// - Parameters:
  ///  - nickname: 닉네임
  ///  - image: 프로필 이미지
  func requestSignUp(
    nickname: String,
    image: Data?
  ) {
    LoadingIndicator.showLoading()
    
    // 로그인 정보 유무 확인
    guard let signInInfo = signInInfo else { return }
    
    let registerInfo = RegisterInfo(
      socialUuid: signInInfo.socialUuid,
      socialType: signInInfo.socialType,
      nickname: nickname,
      image: image
    )
    
    // 닉네임 중복 검사
    self.worker?.checkDuplicateNickname(
      nickname: nickname,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isDuplicated = response?.data else { return }
        
        if isDuplicated {
          self.presentAlert(message: AlertMessage.isDuplicatedNickname.rawValue)
          
        } else {
          
          self.worker?.requestRegister(
            registerInfo: registerInfo,
            completionHandler: { [weak self] response in

              guard let self = self else { return }

              self.showErrorAlert(response: response)

              guard let data = response?.data else { return }
              
              guard let isSuccess = self.worker?.saveUserInfo(response: data) else { return }
              
              if isSuccess {
                self.presentAlert(
                  message: AlertMessage.registerDone.rawValue,
                  confirmAction: {
                  self.navigateToMyView()
                }
              )
                
              } else {
                self.presentAlert(
                  message: AlertMessage.registerFailed.rawValue)
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
  ///  - nickname: 닉네임
  ///  - image: 프로필 이미지
  func requestEditProfile(
    nickname: String,
    image: Data?
  ) {
    
    LoadingIndicator.showLoading()

    guard let originNickname = self.userDetail?.nickname else { return }

    self.worker?.isChangedUserData(
      originNickname: originNickname,
      originImage: self.userDetail?.image,
      inputedNickname: nickname,
      inputedImage: image,
      completionHandler: { (newNickname, newImage) in

        if newNickname == nil, newImage == nil {
          self.navigateToMyView()

          return
        }

        // 닉네임 중복검사
        self.worker?.checkDuplicateNickname(
          nickname: nickname,
          completionHandler: { [weak self] response in

            guard let self = self else { return }

            self.showErrorAlert(response: response)

            guard let isDuplicated = response?.data else { return }

            // 본인이 사용하고 있는 닉네임이 아니고,
            // 중복 검사 결과 true일 경우 이미 사용 중인 닉네임 noti
            if nickname != self.userDetail?.nickname,
               isDuplicated {

              self.presentAlert(message: AlertMessage.isDuplicatedNickname.rawValue)

            } else {

              // 프로필 수정 api 호출
              self.worker?.requestEditProfile(
                nickname: newNickname,
                image: newImage,
                completionHandler: { message in

                  self.presentAlert(
                    message: message,
                    confirmAction: {
                      self.router?.navigateToMyView()
                    }
                  )
                }
              )
            }
          }
        )
      }
    )
  }
}

extension ProfileSettingInteractor {

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: AlertMessage.unknownedError.rawValue)
      }
      return
    }

    guard response.data != nil else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: response.message)
      }
      return
    }
  }

  private func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    LoadingIndicator.hideLoading()
    self.presenter?.presentAlert(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
