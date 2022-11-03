//
//  ProfileSettingInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingInteractorProtocol {
  var worker: ProfileSettingWorkerProtocol? { get set }
  var presenter: ProfileSettingPresenterProtocol? { get set }

  var loginInfo: LoginInfo? { get set }
}

final class ProfileSettingInteractor: ProfileSettingInteractorProtocol {

  // MARK: - Properties

  var worker: ProfileSettingWorkerProtocol?
  var presenter: ProfileSettingPresenterProtocol?

  var loginInfo: LoginInfo?

}
