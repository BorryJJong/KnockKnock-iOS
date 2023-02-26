//
//  BottomSheetPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/26.
//

import Foundation

final class BottomSheetPresenter: BottomSheetPresenterProtocol {
  var view: BottomSheetViewProtocol?

  func presentOptions(
    options: [String],
    bottomSheetType: BottomSheetSize
  ) {
    self.view?.fetchOptions(
      options: options,
      bottomSheetType: bottomSheetType
    )
  }
}
