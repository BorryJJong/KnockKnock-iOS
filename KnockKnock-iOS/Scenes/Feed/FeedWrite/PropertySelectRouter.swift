//
//  PropertySelectRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/21.
//

import UIKit

protocol PropertyDelegate: AnyObject {
  func getSelectedProperty(propertyType: PropertyType, selection: [String])
}

protocol PropertySelectRouterProtocol {
  static func createPropertySelectView(delegate: PropertyDelegate, propertyType: PropertyType) -> UIViewController

  func passDataToFeedWriteView(source: PropertySelectViewProtocol, propertyType: PropertyType, selectedProperties: [String])
  func navigateToFeedWriteView(source: PropertySelectViewProtocol)
}

final class PropertySelectRouter: PropertySelectRouterProtocol {

  weak var delegate: PropertyDelegate?

  static func createPropertySelectView(
    delegate: PropertyDelegate,
    propertyType: PropertyType
  ) -> UIViewController {

    let view = PropertySelectViewController()
    let router = PropertySelectRouter()

    view.router = router
    view.propertyType = propertyType

    router.delegate = delegate

    return view
  }

  func passDataToFeedWriteView(
    source: PropertySelectViewProtocol,
    propertyType: PropertyType,
    selectedProperties: [String]
  ) {
    self.delegate?.getSelectedProperty(
      propertyType: propertyType,
      selection: selectedProperties
    )
    self.navigateToFeedWriteView(source: source)
  }

  func navigateToFeedWriteView(source: PropertySelectViewProtocol) {
    guard let sourceView = source as? PropertySelectViewController else { return }
    sourceView.navigationController?.popViewController(animated: true)
  }
}
