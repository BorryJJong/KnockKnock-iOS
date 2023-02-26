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
    options: [BottomSheetOption],
    bottomSheetSize: BottomSheetSize
  ) {
    self.view?.fetchOptions(
      options: options,
      bottomSheetSize: bottomSheetSize
    )
  }

  func presentDistrictContent(
    content: [String],
    districtsType: DistrictsType?,
    bottomSheetSize: BottomSheetSize
  ) {
    self.view?.fetchDistrictsContent(
      content: content,
      districtsType: districtsType,
      bottomSheetSize: bottomSheetSize
    )
  }
}
