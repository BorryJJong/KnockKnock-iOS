//
//  BottomSheetViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

protocol BottomSheetViewProtocol: AnyObject {
}

final class BottomSheetViewController: BaseViewController<BottomSheetView> {
  
  // MARK: - Properties
  
  private var options: [String] = []
  var districtsType: DistrictsType?
  
  var router: BottomSheetRouterProtocol?
  var deleteAction: (() -> Void)?
  var editAction: (() -> Void)?
  
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
  }
  
  // MARK: - Bind

  func setBottomSheetContents(
    contents: [String],
    bottomSheetType: BottomSheetType
  ) {
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
        self.router?.passCityDataToShopSearch(city: options[indexPath.row])
      case .county:
        self.router?.passCountyDataToShopSearch(county: options[indexPath.row])
      }
    } else {
      
      let option = BottomSheetOption(rawValue: options[indexPath.row])
      
      switch option {
      case .postDelete:
        self.showAlert(
          content: "게시글을 삭제하시겠습니까?",
          confirmActionCompletion: {
            self.dismiss(animated: true, completion: self.deleteAction)
          }
        )
        
      case .postEdit:
        self.dismiss(animated: true, completion: self.editAction)
        
      default:
        print("Error")
      }
    }
  }
}
