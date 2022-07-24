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

  private var tableContents: [String] = []

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
    }
    self.containerView.dimmedBackView.alpha = 0.0
  }

  // MARK: - Bind

  func setBottomSheetContents(contents: [String]) {
    self.tableContents = contents
  }

  // MARK: - Gesture

  private func setupGestureRecognizer() {
    let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
    self.containerView.dimmedBackView.addGestureRecognizer(dimmedTap)
    self.containerView.dimmedBackView.isUserInteractionEnabled = true

    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
    swipeGesture.direction = .down
    self.view.addGestureRecognizer(swipeGesture)
  }

  @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
    self.containerView.hideBottomSheet(view: self)
  }

  @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
    if recognizer.state == .ended {
      switch recognizer.direction {
      case .down:
        self.containerView.hideBottomSheet(view: self)
      default:
        break
      }
    }
  }
}

// MARK: - TableView DataSource

extension BottomSheetViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableContents.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withType: BottomMenuCell.self, for: indexPath)
    cell.setData(labelText: tableContents[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("\(indexPath.row) is selected.")
    self.containerView.hideBottomSheet(view: self)
  }
}
