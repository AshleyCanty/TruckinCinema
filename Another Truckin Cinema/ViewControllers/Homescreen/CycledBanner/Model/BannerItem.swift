//
//  BannerItem.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/10/23.
//

import Foundation
import UIKit

/// BannerItem struct
struct BannerItem {
    let type: BannerType?
    let bannerImage: BannerImage
    let icon: BannerIcon
    let description: BannerDescription
    
    init(type: BannerType? = nil, bannerImage: BannerImage, icon: BannerIcon, description: BannerDescription) {
        self.type = type
        self.bannerImage = bannerImage
        self.icon = icon
        self.description = description
    }
}

