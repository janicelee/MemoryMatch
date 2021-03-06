//
//  CardManager.swift
//  MatchMission
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

protocol CardManagerDelegate {
    func didFailWithError(_ error: Error, _ msg: String)
}

class CardManager {

    private let urlString = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    private var cards = [Card]()
    
    var delegate: CardManagerDelegate?
    var numPairs = 10
    
    func getCard(_ index: Int) -> Card {
        return cards[index]
    }
    
    func getCards() -> [Card] {
        return cards
    }
    
    func checkCardsMatch(_ cardA: Card, _ cardB: Card) -> Bool {
        var isMatch = false
        
        if cardA.getImageURL() == cardB.getImageURL() {
            cardA.setIsMatched(to: true)
            cardB.setIsMatched(to: true)
            isMatch = true
        } else {
            cardA.setIsFaceUp(to: false)
            cardB.setIsFaceUp(to: false)
            isMatch = false
        }
        return isMatch
    }
    
    func allCardsMatched() -> Bool {
        for card in cards {
            if !card.getIsMatched() {
                return false
            }
        }
        return true
    }
    
    // MARK: - Setup & Networking Methods
    
    func setup(_ onComplete: @escaping () -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!, error!.localizedDescription)
                    return
                }
                
                if let data = data {
                    let imageURLs = self.getImageURLs(data)
                    
                    if (imageURLs.count < self.numPairs) {
                        self.delegate?.didFailWithError(NSError(), "Did not retrieve enough image URLs for the desired number of cards")
                    } else {
                        self.generateCards(with: imageURLs, onComplete)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    private func getImageURLs(_ data: Data) -> [URL] {
        let decoder = JSONDecoder()
        var imageURLs = [URL]()

        do {
            let decodedData = try decoder.decode(ProductResponse.self, from: data)
            let products = decodedData.products
            
            var ids = Set<Int>()
            var titles = Set<String>()
            var srcs = Set<String>()
            
            for product in products {
                let id = product.id
                let title = product.title
                let src = product.image.src
                
                if let url = URL(string: product.image.src), !ids.contains(id), !titles.contains(title), !srcs.contains(src) {
                    imageURLs.append(url)
                    ids.insert(id)
                    titles.insert(title)
                    srcs.insert(src)
                }
            }
        } catch {
            self.delegate?.didFailWithError(error, error.localizedDescription)
        }
        return imageURLs
    }
    
    private func generateCards(with imageURLs: [URL], _ onComplete: @escaping () -> ()) {
        let shuffledImageURLs = imageURLs.shuffled()
        let group = DispatchGroup()
        
        for i in 0..<numPairs {
            group.enter()
            URLSession.shared.dataTask(with: shuffledImageURLs[i]) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!, error!.localizedDescription)
                }
                
                if let data = data, let resultImage = UIImage(data: data) {
                    self.cards.append(Card(resultImage, shuffledImageURLs[i]))
                    self.cards.append(Card(resultImage, shuffledImageURLs[i]))
                }
                group.leave()
            }.resume()
        }
        
        group.notify(queue: .main) {
            self.cards = self.cards.shuffled()
            onComplete()
        }
    }
}
