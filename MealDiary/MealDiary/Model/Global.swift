//
//  Global.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 19..
//  Copyright © 2019년 clap. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Global {
    static let shared: Global = Global()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var cards: BehaviorRelay<[ContentCard]> = BehaviorRelay<[ContentCard]>(value: [])
    
    var photoDatas: [Data?] = []
    var titleText: String = ""
    var detailText: String = ""
    var hashTagList: [String] = []
    var restaurantName: String = ""
    var restaurantLocation: String = ""
    var restaurantLatitude: Double = 0
    var restaurantLongitude: Double = 0
    var score: Int = 0
    
    init() {
        let cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        var cardArray: [ContentCard] = []
        for key in cardDict.keys {
            let value = cardDict[key]
            if let data = value as? Data, let card = try? decoder.decode(ContentCard.self, from: data) {
                cardArray.append(card)
            }
        }
        cards.accept(cardArray)
    }
    
    func refresh() {
        photoDatas = []
        titleText = ""
        detailText = ""
        hashTagList = []
        restaurantName = ""
        restaurantLocation = ""
        restaurantLatitude = 0
        restaurantLongitude = 0
        score = 0
    }
    
    func save() {
        let card = ContentCard(id: UUID().uuidString, photoDatas: photoDatas, titleText: titleText, detailText: detailText, hashTagList: hashTagList, restaurantName: restaurantName, restaurantLocation: restaurantLocation, restaurantLatitude: restaurantLatitude, restaurantLongitude: restaurantLongitude, date: Date(), score: score)
        
        modify(card: card)
    }
    
    func modify(card: ContentCard) {
        guard let data = try? encoder.encode(card) else { return }
        var cardArray = cards.value
        cardArray.append(card)
        cards.accept(cardArray)
        
        var cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        cardDict[card.id] = data
        AssetManager.save(data: cardDict, for: DictKeyword.card.rawValue)
    }
    
    func delete(card: ContentCard) {
        var cardArray = cards.value
        for i in 0..<cardArray.count {
            let c = cardArray[i]
            if c.id == card.id {
                cardArray.remove(at: i)
                cards.accept(cardArray)
                break
            }
        }
        
        var cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        cardDict.removeValue(forKey: card.id)
        AssetManager.save(data: cardDict, for: DictKeyword.card.rawValue)
    }
    
    func searchBy(_ query: String) -> [ContentCard] {
        var searchResult: [ContentCard] = []
        for card in cards.value {
            if card.titleText.contains(query) {
                searchResult.append(card)
            } else if card.hashTagList.contains(query) {
                searchResult.append(card)
            }
        }
        return searchResult
    }
}

enum DictKeyword: String {
    case card
    case hashTag
    case firstVist
}
