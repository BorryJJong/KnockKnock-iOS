//
//  MyInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import Foundation

protocol MyInteractorProtocol {
  var router: MyRouterProtocol? { get set }
  var worker: MyWorkerProtocol? { get set }
  var presenter: MyPresenter? { get set }

  func fetchMenuData()
  func fetchNickname() 
  func requestSignOut()
  func requestWithdraw()

  func navigateToLoginView()
  func navigateToPolicyView(policyType: MyMenuType)
  func navigateToProfileSettingView()
}

final class MyInteractor: MyInteractorProtocol {

  // MARK: - Properties

  var router: MyRouterProtocol?
  var worker: MyWorkerProtocol?
  var presenter: MyPresenter?

  private var isSignedIn: Bool = false {
    didSet {
      self.fetchMenuData()
      self.presenter?.presentLoginStatus(isSignedIn: self.isSignedIn)
    }
  }

  // MARK: - Initailize

  init() {
    self.setNotification()
  }

  // Busniess Logic

  func fetchMenuData() {
    self.worker?.fetchMenuData(
      isSignedIn: self.isSignedIn,
      completionHandler: { [weak self] menu in
        guard let self = self else { return }

        self.presenter?.presentMenuData(myMenu: menu)
      }
    )
  }

  func fetchNickname() {
    self.worker?.fetchNickname(
      completionHandler: { [weak self] nickname in
        guard let self = self else { return }

        self.presenter?.presentNickname(nickname: nickname)
      }
    )
  }

  func requestSignOut() {
    self.worker?.requestSignOut(
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data,
              isSuccess else {

          self.presentAlert(message: "처리 중 오류가 발생하였습니다.")
          return
        }
      }
    )
  }

  func requestWithdraw() {
    self.worker?.requestWithdraw(
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data,
              isSuccess else {

          self.presentAlert(message: "처리 중 오류가 발생하였습니다.")
          return
        }

        self.presentAlert(message: "성공적으로 탈퇴 처리 되었습니다.")
      }
    )
  }

  // Routing

  func navigateToLoginView() {
    self.router?.navigateToLoginView()
  }

  func navigateToPolicyView(policyType: MyMenuType) {
    self.router?.navigateToPolicyView(policyType: policyType)
  }

  func navigateToProfileSettingView() {
    self.router?.navigateToProfileSettingView()
  }
}

  // MARK: - Inner Actions

extension MyInteractor {

  // Notification Center

  func setNotification() {
    NotificationCenter.default.addObserver(
      forName: .signInCompleted,
      object: nil,
      queue: nil
    ) { _ in
      self.isSignedIn = true

    }

    NotificationCenter.default.addObserver(
      forName: .signOutCompleted,
      object: nil,
      queue: nil
    ) { _ in
      self.isSignedIn = false
    }

    NotificationCenter.default.addObserver(
      forName: .profileUpdated,
      object: nil,
      queue: nil
    ) { _ in
      self.fetchNickname()
    }
  }

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: "네트워크 연결을 확인해 주세요.")
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
    self.presenter?.presentAlert(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
