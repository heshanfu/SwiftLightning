//
//  LNDDebugLevelViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-11.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LNDDebugLevelDisplayLogic: class {
  func updateFetchSubsystems(viewModel: LNDDebugLevel.FetchSubsystems.ViewModel)
  func displayChangedDebugLevel(viewModel: LNDDebugLevel.ChangeDebugLevel.ViewModel)
  func displayError(viewModel: LNDDebugLevel.ErrorVM)
}

class LNDDebugLevelViewController: SLViewController, LNDDebugLevelDisplayLogic, SLFormDebugLevelViewDelegate {
  var interactor: LNDDebugLevelBusinessLogic?
  var router: (NSObjectProtocol & LNDDebugLevelRoutingLogic & LNDDebugLevelDataPassing)?

  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = LNDDebugLevelInteractor()
    let presenter = LNDDebugLevelPresenter()
    let router = LNDDebugLevelRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  
  // MARK: View lifecycle
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var systemDebugLevelView: SLFormDebugLevelView!

  override func viewDidLoad() {
    super.viewDidLoad()
    systemDebugLevelView.delegate = self
    
    let request = LNDDebugLevel.FetchSubsystems.Request()
    interactor?.fetchSubsystems(request: request)
  }
  
  
  // MARK: Debug Level Views Delegate Conformance
  
  func stringsForLevel(_ debugLevelView: SLFormDebugLevelView) -> [String] {
    if debugLevelView === systemDebugLevelView {
      return LNDDebugLevel.Level.systemLevelsString
    } else {
      return LNDDebugLevel.Level.subsystemLevelsString
    }
  }
  
  func debugLevelViewExpanded(_ debugLevelView: SLFormDebugLevelView) {
    // Hide all other views
//    if debugLevelView != self.systemDebugLevelView {
//      self.systemDebugLevelView.togglePicker(forceHide: true)
//    }
//    for view in self.subsystemViews {
//      if debugLevelView != view {
//        view.togglePicker(forceHide: true)
//      }
//    }
    self.stackView.layoutIfNeeded()
  }
  
  func debugLevelView(_ debugLevelView: SLFormDebugLevelView, didSelectLevel level: Int) {
    if debugLevelView == systemDebugLevelView, let debugLevel = LNDDebugLevel.Level(rawValue: level+1) {  // +1 because not showing N/C for system picker
      if debugLevel == LNDDebugLevel.Level.individual {
        UIView.animate(withDuration: SLDesign.Constants.defaultTransitionDuration) {
          for view in self.subsystemViews { view.isHidden = false }
          self.stackView.layoutIfNeeded()
        }
      } else {
        UIView.animate(withDuration: SLDesign.Constants.defaultTransitionDuration) {
          for view in self.subsystemViews { view.isHidden = true }
          self.stackView.layoutIfNeeded()
        }
      }
    }
  }
  
  
  // MARK: Fetch Subsystems from LND
  
  private var subsystemViews = [SLFormDebugLevelView]()
  
  func updateFetchSubsystems(viewModel: LNDDebugLevel.FetchSubsystems.ViewModel) {
    DispatchQueue.main.async {
      guard let buttonView = self.stackView.arrangedSubviews.last else {
        SLLog.fatal("No last vew in stack")
      }
      self.stackView.removeArrangedSubview(buttonView)
    
      for subsystemString in viewModel.subsystems {
        let debugView = SLFormDebugLevelView()
        debugView.subSystemLabel.text = subsystemString
        debugView.setContentCompressionResistancePriority(.required, for: .vertical)
        debugView.delegate = self
        debugView.isHidden = true
        self.subsystemViews.append(debugView)
        self.stackView.addArrangedSubview(debugView)
      }
      self.stackView.addArrangedSubview(buttonView)
    }
  }
  
  
  
  
  // MARK: Change Debug Level
  
  @IBAction func changeDebugLevel(_ sender: SLBarButton) {
    let systemLevel = LNDDebugLevel.Level(rawValue: systemDebugLevelView.selectedRow + 1)  // +1 because of no N/C
    
    if systemLevel == .individual {
      var subsystemLevels = [String : LNDDebugLevel.Level]()
      
      for debugView in subsystemViews {
        guard let subsystem = debugView.subSystemLabel.text else {
          SLLog.assert("Debug Form View subsystemLabel = nil")
          continue
        }
        let level = LNDDebugLevel.Level(rawValue: debugView.selectedRow)
        
        // Submit only the entries with something specified
        if level != LNDDebugLevel.Level.noChange {
          subsystemLevels[subsystem] = level
        }
      }
      
      let request = LNDDebugLevel.ChangeDebugLevel.Request(systemLevel: nil,
                                                           subsystemLevels: subsystemLevels)
      interactor?.changeDebugLevel(request: request)
      
    } else {
      let request = LNDDebugLevel.ChangeDebugLevel.Request(systemLevel: systemLevel,
                                                           subsystemLevels: nil)
      interactor?.changeDebugLevel(request: request)
    }
  }
  
  func displayChangedDebugLevel(viewModel: LNDDebugLevel.ChangeDebugLevel.ViewModel) {
    DispatchQueue.main.async {
      let alertDialog = UIAlertController(title: viewModel.title,
                                          message: viewModel.msg,
                                          preferredStyle: .alert).addAction(title: "OK", style: .default) { _ in
        self.router?.routeToSettingsMain()
      }
      self.present(alertDialog, animated: true, completion: nil)
    }
  }
  
  
  // MARK: Error Dialog
  
  func displayError(viewModel: LNDDebugLevel.ErrorVM) {
    DispatchQueue.main.async {
      let alertDialog = UIAlertController(title: viewModel.errTitle,
                                          message: viewModel.errMsg,
                                          preferredStyle: .alert).addAction(title: "OK", style: .default)
      self.present(alertDialog, animated: true, completion: nil)
    }
  }
  
  
  // MARK: Back Arrow Tapped
  
  @IBAction func backArrowTapped(_ sender: UIBarButtonItem) {
    router?.routeToSettingsMain()
  }
}