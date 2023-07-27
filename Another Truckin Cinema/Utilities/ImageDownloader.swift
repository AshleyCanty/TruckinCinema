//
//  ImageDownloader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/24/23.
//

import Foundation
import UIKit

/// ImageDownloader class
class ImageDownloader {
    static func downloadImage(_ urlString: String, completion: ((_ image: UIImage?, _ urlString: String?) -> ())?)  {
        guard let url = URL(string: urlString) else {
            completion?(nil, urlString)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion?(nil, urlString)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion?(nil, urlString)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                completion?(image, urlString)
                return
            }
            completion?(nil, urlString)
        }.resume()
    }
}
