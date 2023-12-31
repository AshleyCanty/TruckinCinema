//
//  SnackBarItemManager.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/28/23.
//

import Foundation


struct SnackBarItemManager {
    
    var items = [SnackBarItemModel]()
    
    init(type: SnackBarItemType) {
        switch type {
        case .snacks:
            items = setDataForSnackItems()
        case .popcorn:
            items = setDataForPopcornItems()
        case .beverages:
            items = setDataForBeverageItems()
        }
    }
    
    /// setup popcorn items
    private func setDataForPopcornItems() -> [SnackBarItemModel] {
        let mainMenuName = SnackBarItemMain.Popcorn.getStringVal()
        return [
            SnackBarItemModel(mainMenu: mainMenuName,
                              name: SnackBarPopcornOption.Traditional.getStringVal(),
                              image: SnackBarPopcornImage.Traditional.getStringVal(),
                              priceString: SnackBarPopcornPrice.Traditional.getStringVal(),
                              priceNumber: SnackBarPopcornPrice.Traditional.getDoubleVal()),
            SnackBarItemModel(mainMenu: mainMenuName,
                              name: SnackBarPopcornOption.GourmetSingle.getStringVal(),
                              image: SnackBarPopcornImage.GourmetSingle.getStringVal(),
                              priceString: SnackBarPopcornPrice.GourmetSingle.getStringVal(),
                              priceNumber: SnackBarPopcornPrice.GourmetSingle.getDoubleVal()),
            SnackBarItemModel(mainMenu: mainMenuName,
                              name: SnackBarPopcornOption.GourmetDuo.getStringVal(),
                              image: SnackBarPopcornImage.GourmetDuo.getStringVal(),
                              priceString: SnackBarPopcornPrice.GourmetDuo.getStringVal(),
                              priceNumber: SnackBarPopcornPrice.GourmetDuo.getDoubleVal())
        ]
    }
    
    /// setup beverage items
    private func setDataForBeverageItems() -> [SnackBarItemModel] {
        let mainMenuName = SnackBarItemMain.Beverages.getStringVal()
        return [
            SnackBarItemModel(mainMenu: mainMenuName, name: SnackBarBeverageOption.Small.getStringVal(),
                              image: SnackBarBeverageImage.Small.getStringVal(),
                              priceString: SnackBarBeveragePrice.Small.getStringVal(),
                              priceNumber: SnackBarBeveragePrice.Small.getDoubleVal()),
            SnackBarItemModel(mainMenu: mainMenuName, name: SnackBarBeverageOption.Medium.getStringVal(),
                              image: SnackBarBeverageImage.Medium.getStringVal(),
                              priceString: SnackBarBeveragePrice.Medium.getStringVal(),
                              priceNumber: SnackBarBeveragePrice.Medium.getDoubleVal()),
            SnackBarItemModel(mainMenu: mainMenuName, name: SnackBarBeverageOption.Large.getStringVal(),
                              image: SnackBarBeverageImage.Large.getStringVal(),
                              priceString: SnackBarBeveragePrice.Large.getStringVal(),
                              priceNumber: SnackBarBeveragePrice.Large.getDoubleVal())
        ]
    }
    
    /// setup snack items
    private func setDataForSnackItems() -> [SnackBarItemModel] {
        let mainMenuName = SnackBarItemMain.Snacks.getStringVal()
        return [
            SnackBarItemModel(mainMenu: mainMenuName, name: SnackBarSnackOption.MixedCandy.getStringVal(),
                              image: SnackBarSnackImage.MixedCandy.getStringVal(),
                              priceString: SnackBarSnackPrice.MixedCandy.getStringVal(),
                              priceNumber: SnackBarSnackPrice.MixedCandy.getDoubleVal()),
            SnackBarItemModel(mainMenu: mainMenuName, name: SnackBarSnackOption.Nachos.getStringVal(),
                              image: SnackBarSnackImage.Nachos.getStringVal(),
                              priceString: SnackBarSnackPrice.Nachos.getStringVal(),
                              priceNumber: SnackBarSnackPrice.Nachos.getDoubleVal()),
            SnackBarItemModel(mainMenu: mainMenuName, name: SnackBarSnackOption.PretzelBites.getStringVal(),
                              image: SnackBarSnackImage.PretzelBites.getStringVal(),
                              priceString: SnackBarSnackPrice.PretzelBites.getStringVal(),
                              priceNumber: SnackBarSnackPrice.PretzelBites.getDoubleVal())
        ]
    }
}
