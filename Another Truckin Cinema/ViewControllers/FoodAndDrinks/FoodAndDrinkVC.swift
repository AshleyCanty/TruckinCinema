//
//  FoodAndDrinkVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit

/// FoodAndDrinkVC class
class FoodAndDrinkVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: TabBarItemTitle.FoodAndDrinks.getString())
        super.viewWillAppear(animated)
    }
    
}
