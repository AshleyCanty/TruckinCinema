//
//  TicketSelectionVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit

class TicketSelectionVC: BaseViewController, AppNavigationBarDelegate {

    init(movieDetails: String) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: "TicketSelectionVC")
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: nil), animated: true)

        addCustomNavBar()
    }
    
    func addCustomNavBar() {
        let appNavBar = AppNavigationBar(type: .MovieRSVP)
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.HeightWithSubtitle)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
    }
}

extension TicketSelectionVC {
    func didPressNavBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPressNavBarRightButton() {
        // exit the flow? show alert
        showAlertToCancelOrder()
    }
    
    func showAlertToCancelOrder() {
        var cancelAlert: UIAlertController!
        
        let handlerNo: ((UIAlertAction) -> ())? = { _ in
            cancelAlert.dismiss(animated: true)
        }
        let handlerYes: ((UIAlertAction) -> ())? = { [weak self] _ in
            guard let sSelf = self else { return }
            if let movieDetailsVC = sSelf.navigationController?.viewControllers.filter({ $0 is MovieDetailsVC }).first {
                sSelf.navigationController?.popToViewController(movieDetailsVC, animated: true)
            }
        }
        cancelAlert = AppAlertController.createAlertToCancelOrder(handlerActionNo: handlerNo, handlerActionYes: handlerYes)
        self.present(cancelAlert, animated: true)
    }
}
