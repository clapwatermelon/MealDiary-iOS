//
//  TitleTableViewCell.swift
//  MealDiary
//
//  Created by 박수현 on 16/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleTextField: UITextField!
    static let identifier = "TitleTableViewCell"
    
    func setUp() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "iconStar")
        attachment.bounds = CGRect(x: 6, y: 10, width: 6, height: 6)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let placeHolder = NSMutableAttributedString(string: "제목")
        placeHolder.append(attachmentStr)
        
        titleTextField.attributedPlaceholder = placeHolder
    }
}
