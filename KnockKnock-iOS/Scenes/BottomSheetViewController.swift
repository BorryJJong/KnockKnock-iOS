//
//  BottomSheetViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

class BottomSheetViewController: BaseViewController<BottomSheetView> {

  // MARK: - Properties

  let bottomHeight: CGFloat = 150
  private var tableContents: [String] = ["수정", "삭제"]

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.setupGestureRecognizer()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showBottomSheet()
  }
  
  // MARK: - Functions

  override func setupConfigure() {
    self.view.backgroundColor = .clear
    self.containerView.tableView.do {
      $0.delegate = self
      $0.dataSource = self
    }
    self.containerView.dimmedBackView.alpha = 0.0
  }

  private func setupGestureRecognizer() {
    let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
    self.containerView.dimmedBackView.addGestureRecognizer(dimmedTap)
    self.containerView.dimmedBackView.isUserInteractionEnabled = true

    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
    swipeGesture.direction = .down
    self.view.addGestureRecognizer(swipeGesture)
  }

  private func showBottomSheet() {
    let safeAreaHeight: CGFloat = self.containerView.safeAreaLayoutGuide.layoutFrame.height
    let bottomPadding: CGFloat = self.containerView.safeAreaInsets.bottom

    self.containerView.bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - self.bottomHeight

    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
      self.containerView.dimmedBackView.alpha = 0.5
      self.containerView.layoutIfNeeded()
    }, completion: nil)
  }

  private func hideBottomSheet() {
    let safeAreaHeight = self.containerView.safeAreaLayoutGuide.layoutFrame.height
    let bottomPadding = self.containerView.safeAreaInsets.bottom

    self.containerView.bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
      self.containerView.dimmedBackView.alpha = 0.0
      self.containerView.layoutIfNeeded()
    }) { _ in
      if self.presentingViewController != nil {
        self.dismiss(animated: false, completion: nil)
      }
    }
  }

  // UITapGestureRecognizer 연결 함수 부분
  @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
    self.hideBottomSheet()
  }

  // UISwipeGestureRecognizer 연결 함수 부분
  @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
    if recognizer.state == .ended {
      switch recognizer.direction {
      case .down:
        self.hideBottomSheet()
      default:
        break
      }
    }
  }
}

extension BottomSheetViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableContents.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: BottomMenuCell.self, for: indexPath)
    cell.contentsLabel.text = tableContents[indexPath.row]
    return cell
  }
}

extension BottomSheetViewController: UITableViewDelegate {
}
