//
//  MainCardTableViewCell.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class MainCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var threeDotsButton: UIButton!
    
    static let identifier = "MainCardTableViewCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp() {
        cardNumberLabel.clipsToBounds = true
        cardNumberLabel.layer.cornerRadius = 10
    }
}
