//
//  BaseViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import UIKit

class BaseViewController<View: UIView>: UIViewController {
  
  // MARK: - Properties
  
  let containerView: View
  
  lazy private(set) var className: String = {
    return type(of: self).description().components(separatedBy: ".").last ?? ""
  }()
  
  private(set) var didSetupConstraints = false
  
  // MARK: - Initialize
  
  init(view: View) {
    self.containerView = view
    super.init(nibName: nil, bundle: nil)
  }
  
  convenience init() {
    self.init(view: View())
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }
  
  deinit {
    print("DEINIT: \(self.className)")
  }
  
  // MARK: View Lifecycle
  
  override func loadView() {
    super.loadView()
    self.view = self.containerView
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setupConfigure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK: Configure
  
  func setupConfigure() { /* override point */ }
}
