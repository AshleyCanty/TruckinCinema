//
//  UIImage+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/10/23.
//

import Foundation
import UIKit


extension UIImage {

    /// A convenience init method used with images found in assets folder
    convenience init(imgNamed: String) {
        self.init(named: imgNamed)!
    }
}


extension UIImageView {
    func downloadImage(from url: URL) async throws {
        let imageData = try await URLCache.shared.downloadImageData(for: url)
        let image = UIImage(data: imageData)

        DispatchQueue.main.async { [weak self] in
            if let castedSelf = self as? CustomImageView {
                castedSelf.hideSpinner()
            }
            self?.image = image
        }
    }
}
