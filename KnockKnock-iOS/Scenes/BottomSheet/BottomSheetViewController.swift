//
//  BottomSheetViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

final class BottomSheetViewController: BaseViewController<BottomSheetView> {
  
  // MARK: - Properties

  var interactor: BottomSheetInteractorProtocol?
  
  private var options: [BottomSheetOption] = []
  private var districtContents: [String] = []
  private var districtsType: DistrictsType?

  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchBottomSheetOptions()
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

extension BottomSheetViewController: BottomSheetViewProtocol, AlertProtocol {
  func fetchOptions(
    options: [BottomSheetOption],
    bottomSheetSize: BottomSheetSize
  ) {
    self.options = options
    self.containerView.bottomSheetSize = bottomSheetSize

    DispatchQueue.main.async {
      self.containerView.tableView.reloadData()
    }
  }

  func fetchDistrictsContent(
    content: [String],
    districtsType: DistrictsType?,
    bottomSheetSize: BottomSheetSize
  ) {
    self.districtContents = content
    self.districtsType = districtsType
    self.containerView.bottomSheetSize = bottomSheetSize

    DispatchQueue.main.async {
      self.containerView.tableView.reloadData()
    }
  }

  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: @escaping (() -> Void)
  ) {
    DispatchQueue.main.async {
      self.showAlert(
        message: message,
        isCancelActive: isCancelActive,
        confirmAction: confirmAction
      )
    }
  }
}

// MARK: - TableView DataSource

extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {

    guard self.districtsType != nil else {
      return self.options.count
    }

    return self.districtContents.count

  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(
      withType: BottomMenuCell.self,
      for: indexPath
    )
    guard self.districtsType != nil else {
      cell.setData(labelText: options[indexPath.row].title)
      cell.setSelected(true, animated: false)

      return cell
    }

    cell.setData(labelText: self.districtContents[indexPath.row])

    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    if let districtsType = self.districtsType {
      switch districtsType {

      case .city:
        self.interactor?.passCityDataToShopSearch(city: districtContents[indexPath.row])

      case .county:
        self.interactor?.passCountyDataToShopSearch(county: districtContents[indexPath.row])

      }
    } else {
      
      let option = options[indexPath.row]
      
      switch option {

      case .postDelete:
        DispatchQueue.main.async {
          self.showAlert(
            message: AlertMessage.feedDeleteConfirm.rawValue,
            isCancelActive: true,
            confirmAction: {
              self.interactor?.dismissView(action: option.getAction())
            }
          )
        }
        
      case .postEdit:
        self.interactor?.dismissView(action: option.getAction())

      case .postShare:
        self.interactor?.sharePost()

      case .userBlock:
        DispatchQueue.main.async {
          self.showAlert(
            message: AlertMessage.userBlockConfirm.rawValue,
            isCancelActive: true,
            confirmAction: {
              self.interactor?.dismissView(action: option.getAction())
            }
          )
        }

      case .challengeNew:
        self.interactor?.passChallengeSortType(sortType: .new)

      case .challengePopular:
        self.interactor?.passChallengeSortType(sortType: .popular)

      case .postHide:
        DispatchQueue.main.async {
          self.showAlert(
            message: AlertMessage.feedHideConfirm.rawValue,
            isCancelActive: true,
            confirmAction: {
              self.interactor?.dismissView(action: option.getAction())
            }
          )
        }

      case .postReport:
        self.interactor?.dismissView(action: option.getAction())
      }
    }
  }
}
