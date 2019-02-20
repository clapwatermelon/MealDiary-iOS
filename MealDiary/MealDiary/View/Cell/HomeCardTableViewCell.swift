//
//  HomeCardTableViewCell.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 3..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

class HomeCardTableViewCell: UITableViewCell {
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var underLineView: UIView!
    static let identifier = "HomeCardTableViewCell"
    
    func setUp(with card: ContentCard) {
        if let data = card.photoDatas.first as? Data {
            backgroundImage.image = UIImage(data: data)
        }
        backgroundImage.layer.cornerRadius = 10
        dimmedView.layer.cornerRadius = 10
        pointLabel.text = card.score.description
        titleTextLabel.text = card.titleText
        dateLabel.text = card.date.toString()
        var hashTag = ""
        card.hashTagList.forEach { hashTag += ($0 + " ") }
        hashTagLabel.text = hashTag
        
        let width = titleTextLabel.intrinsicContentSize.width
        underLineView.frame = CGRect(x: 40, y: 55, width: width + 10, height: 19)
        self.selectionStyle = .none
    }
}
