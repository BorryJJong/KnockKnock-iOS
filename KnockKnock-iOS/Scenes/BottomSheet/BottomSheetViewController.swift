//
//  BottomSheetViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

protocol BottomSheetViewProtocol {
}

final class BottomSheetViewController: BaseViewController<BottomSheetView> {
  
  // MARK: - Properties
  
  private var options: [String] = []
  var districtsType: DistrictsType?
  
  var router: BottomSheetRouterProtocol?
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    
    self.containerView.alertView.do {
      $0.confirmButton.addTarget(
        self,
        action: #selector(self.alertConfirmButtonDidTap(_:)),
        for: .touchUpInside
      )
      $0.cancelButton.addTarget(
        self,
        action: #selector(self.alertCancelButtonDidTap(_:)),
        for: .touchUpInside
      )
    }
  }
  
  // MARK: - Bind

  func setBottomSheetContents(contents: [String], bottomSheetType: BottomSheetType) {
    self.options = contents
    self.containerView.bottomSheetType = bottomSheetType
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
  
  // MARK: - Alert View Button Actions
  
  @objc private func alertCancelButtonDidTap(_ sender: UIButton) {
    self.containerView.do {
      $0.bottomSheetView.isHidden = false
      $0.setHiddenStatusAlertView(isHidden: true)
      $0.tableView.reloadData()
    }
  }
  
  @objc private func alertConfirmButtonDidTap(_ sender: UIButton) {
    self.containerView.hideBottomSheet(view: self)
  }
}

// MARK: - Bottom Sheet View Protocol

extension BottomSheetViewController: BottomSheetViewProtocol {
  
}

// MARK: - TableView DataSource

extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.options.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueCell(
      withType: BottomMenuCell.self,
      for: indexPath
    )
    cell.setData(labelText: options[indexPath.row])
    cell.setSelected(true, animated: false)
    
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    if let districtsType = self.districtsType {
      switch districtsType {
      case .city:
        self.router?.passCityDataToShopSearch(source: self, city: options[indexPath.row])
      case .county:
        self.router?.passCountyDataToShopSearch(source: self, county: options[indexPath.row])
      }
    } else {
      
      let option = BottomSheetOption(rawValue: options[indexPath.row])
      
      switch option {
      case .delete:
        self.containerView.do {
          $0.setHiddenStatusAlertView(isHidden: false)
          $0.alertView.bind(
            content: "댓글을 삭제하시겠습니까?",
            isCancelActive: true
          )
        }
        
      case .edit:
        self.containerView.hideBottomSheet(view: self)
        
        // 추후 케이스 별 코드 작성 필요
        
      default:
        print("Error")
      }
    }
  }
}