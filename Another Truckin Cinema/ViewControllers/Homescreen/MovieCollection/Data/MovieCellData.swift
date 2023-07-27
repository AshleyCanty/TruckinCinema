//
//  MovieCellData.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/15/23.
//

import Foundation
import UIKit

struct MovieCellData {
    static let movieCollectionItems: [MovieCellItem] = [
        MovieCellItem(posterURL: "poster-guardians", title: "Guardians of the Galaxy Vol. 4", id: UUID().uuidString),
        MovieCellItem(posterURL: "poster-johnwick", title: "John Wick 4", id: UUID().uuidString),
        MovieCellItem(posterURL: "poster-oppenheimer", title: "Oppenheimer", id: UUID().uuidString),
        MovieCellItem(posterURL: "poster-spiderman", title: "Spiderman: Into the Spidey-verse", id: UUID().uuidString)
    ]
}
