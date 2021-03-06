//
//  Card.swift
//  MatchMission
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class Card {
    private let image: UIImage
    private let imageURL: URL
    private var isFaceUp = false
    private var isMatched = false
    
    init(_ image: UIImage, _ imageURL: URL) {
        self.image = image
        self.imageURL = imageURL
    }
    
    func getImage() -> UIImage {
        return image
    }
    
    func getImageURL() -> URL? {
        return imageURL
    }
    
    func getIsFaceUp() -> Bool {
        return isFaceUp
    }
    
    func setIsFaceUp(to value: Bool) {
        self.isFaceUp = value
    }
    
    func getIsMatched() -> Bool {
        return isMatched
    }
    
    func setIsMatched(to value: Bool) {
        self.isMatched = value
    }
}
