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
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var showHideButton: UIButton!
    
    
    static let identifier = "MainCardTableViewCell"
    let underlineAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor : UIColor.gray,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp() {
        cardNumberLabel.clipsToBounds = true
        cardNumberLabel.layer.cornerRadius = 10
        addressLabel.attributedText = NSAttributedString(string: addressLabel.text ?? "", attributes: underlineAttributes)
        showHideButton.setAttributedTitle(NSAttributedString(string: showHideButton.titleLabel?.text ?? "", attributes: underlineAttributes), for: .normal)
    }
}
