//
//  TagHistoryTableViewCell.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 16..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

class TagHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    static let identifier = "TagHistoryTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setWhite() {
        contentView.backgroundColor = .white
        separatorView.isHidden = true
    }
    
}
