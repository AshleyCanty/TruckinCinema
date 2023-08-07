//
//  DriveInLocationsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit

/// DriveInLocationsVC class
class DriveInLocationsVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: TabBarItemTitle.OurDriveIns.getString())
        super.viewWillAppear(animated)
    }
}
