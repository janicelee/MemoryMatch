//
//  Card.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class Card {
    var image: UIImage
    var imageURL: URL?
    var isFaceUp = false
    var isMatched = false
    
    init(_ image: UIImage, _ imageURL: URL) {
        self.image = image
        self.imageURL = imageURL
    }
}
