//
//  PayConfirmRouter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-28.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol PayConfirmRoutingLogic {
  func routeToPayMain()
  func routeToWalletMain()
}


protocol PayConfirmDataPassing {
  var dataStore: PayConfirmDataStore? { get }
}


class PayConfirmRouter: NSObject, PayConfirmRoutingLogic, PayConfirmDataPassing {
  
  weak var viewController: PayConfirmViewController?
  var dataStore: PayConfirmDataStore?
  
  
  // MARK: Routing
  
  func routeToPayMain() {
//    let destinationVC = viewController as! PayMainViewController
//    var destinationDS = destinationVC.router!.dataStore!
//    passDataToPayMain(source: dataStore!, destination: &destinationDS)
    navigateToPayMain(source: viewController!)
  }
  
  func routeToWalletMain() {
    navigateToWalletMain(source: viewController!)
  }

  
  // MARK: Navigation
  
  func navigateToPayMain(source: PayConfirmViewController) {
    guard let navigationController = source.navigationController else {
      SLLog.assert("\(type(of: source)).navigationController = nil")
      return
    }
    navigationController.popViewController(animated: true)
  }
  
  func navigateToWalletMain(source: PayConfirmViewController) {
    guard let navigationController = source.navigationController else {
      SLLog.assert("\(type(of: source)).navigationController = nil")
      return
    }
    
    // Wallet Main is at index 0. So we want the dismissal transition delegate at index 1
    if let navigationDelegate = navigationController.viewControllers[1] as? SLViewController {
      navigationController.delegate = navigationDelegate
    }
    navigationController.popToRootViewController(animated: true)
  }
  
  
  // MARK: Passing data
  
  func passDataToPayMain(source: PayConfirmDataStore, destination: inout PayMainDataStore) {
  }
  
  func passDataToWalletMain(source: PayConfirmDataStore, destination: inout WalletMainDataStore) {
  }
}
