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
    
    func save(card: ContentCard) {
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
                break
            }
        }
        
        var cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        cardDict.removeValue(forKey: card.id)
        AssetManager.save(data: cardDict, for: DictKeyword.card.rawValue)
    }
}

enum DictKeyword: String {
    case card
    case hashTag
    case firstVist
}
