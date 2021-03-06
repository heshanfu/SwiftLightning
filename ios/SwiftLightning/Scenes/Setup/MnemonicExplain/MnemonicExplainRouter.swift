//
//  MnemonicExplainRouter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-18.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol MnemonicExplainRoutingLogic
{
  func routeToMnemonicDisplay()
}

protocol MnemonicExplainDataPassing
{
  var dataStore: MnemonicExplainDataStore? { get }
}

class MnemonicExplainRouter: NSObject, MnemonicExplainRoutingLogic, MnemonicExplainDataPassing
{
  weak var viewController: MnemonicExplainViewController?
  var dataStore: MnemonicExplainDataStore?
  
  // MARK: Routing
  
  func routeToMnemonicDisplay()
  {
    let storyboard = UIStoryboard(name: "MnemonicDisplay", bundle: nil)
    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MnemonicDisplayViewController") as! MnemonicDisplayViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataToMnemonicDisplay(source: dataStore!, destination: &destinationDS)
    navigateToMnemonicDisplay(source: viewController!, destination: destinationVC)
  }

  // MARK: Navigation
  
  func navigateToMnemonicDisplay(source: MnemonicExplainViewController, destination: MnemonicDisplayViewController)
  {
    source.present(destination, animated: true, completion: nil)
  }
  
  // MARK: Passing data
  
  func passDataToMnemonicDisplay(source: MnemonicExplainDataStore, destination: inout MnemonicDisplayDataStore)
  {
    // destination.name = source.name
  }
}
