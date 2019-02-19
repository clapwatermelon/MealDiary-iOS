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
    }
}

enum DictKeyword: String {
    case card
    case hashTag
    case firstVist
}
