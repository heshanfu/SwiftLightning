//
//  ChannelConfirmViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-25.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChannelConfirmDisplayLogic: class
{
  func displayRefreshAll(viewModel: ChannelConfirm.RefreshAll.ViewModel)
}


class ChannelConfirmViewController: UIViewController, ChannelConfirmDisplayLogic
{
  var interactor: ChannelConfirmBusinessLogic?
  var router: (NSObjectProtocol & ChannelConfirmRoutingLogic & ChannelConfirmDataPassing)?

  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ChannelConfirmInteractor()
    let presenter = ChannelConfirmPresenter()
    let router = ChannelConfirmRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshAll()
  }
  
  
  // MARK: Refresh All
  
  @IBOutlet weak var fundingLabelView: SLFormLabelView!
  @IBOutlet weak var nodeLabelView: SLFormNodeView!
  @IBOutlet weak var initPayLabelView: SLFormLabelView!
  @IBOutlet weak var confSpeedLabelView: SLFormLabelView!
  @IBOutlet weak var channelSummaryView: SLFormChSummaryView!
  
  
  func refreshAll() {
    let request = ChannelConfirm.RefreshAll.Request()
    interactor?.refreshAll(request: request)
  }
  
  func displayRefreshAll(viewModel: ChannelConfirm.RefreshAll.ViewModel) {
    fundingLabelView.textLabel.text = viewModel.fundingAmt
    fundingLabelView.refAmtLabel.isHidden = true  // TODO: Fiat/Reference Amount
    
    nodeLabelView.nodePubKeyLabel.text = viewModel.nodePubKey
    nodeLabelView.ipAddressLabel.text = viewModel.nodeIP
    nodeLabelView.portNumberLabel.text = viewModel.nodePort
    
    initPayLabelView.textLabel.text = viewModel.initPayAmt
    initPayLabelView.refAmtLabel.isHidden = true // TODO: Fiat/Reference Amount
    
    confSpeedLabelView.textLabel.text = viewModel.confSpeed
    
    channelSummaryView.canPayAmtLabel.text = viewModel.canPayAmt
    channelSummaryView.canRcvAmtLabel.text = viewModel.canRcvAmt
    channelSummaryView.feeAmtLabel.text = viewModel.fee
  }
  
  
  // MARK: Dismiss
  
  @IBAction func backTapped(_ sender: UIBarButtonItem) {
    router?.routeToChannelOpen()
  }
  
  @IBAction func cancelTapped(_ sender: SLBarButton) {
    router?.routeToChannelOpen()
  }
  
  
  // MARK: Confirm
  
  @IBAction func confirmTapped(_ sender: SLBarButton) {
    
  }
}