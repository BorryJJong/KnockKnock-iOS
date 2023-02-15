//
//  EventDetailPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/15.
//

import UIKit

protocol EventDetailPresenterProtocol: AnyObject {
  var view: EventDetailViewProtocol? { get set}
}

final class EventDetailPresenter: EventDetailPresenterProtocol {

  weak var view: EventDetailViewProtocol?

}
