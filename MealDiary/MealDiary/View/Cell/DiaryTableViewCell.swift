//
//  DiaryTableViewCell.swift
//  MealDiary
//
//  Created by 박수현 on 16/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    static let identifier = "DiaryTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    func setUp() {
        if textView.text == "" {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "iconStar")
            attachment.bounds = CGRect(x: 6, y: 10, width: 6, height: 6)
            
            let attachmentStr = NSAttributedString(attachment: attachment)
            
            var placeHolder = NSMutableAttributedString()
            placeHolder = NSMutableAttributedString(string: " 식후감 ")
            placeHolder.append(attachmentStr)
            
            textView.attributedText = placeHolder
            textView.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.6)
            textView.font = UIFont(name: "HelveticaNeue", size: 16)
        }
    }
    
    func getTextViewHeight(textLength: CGFloat, textViewWidth: CGFloat) -> CGFloat {
        let lineCount = textLength / textViewWidth
        var frame = self.textView.frame
        if lineCount > 1 {
            frame.size.height = 16 * lineCount
            return frame.size.height
        }
        return frame.size.height
    }

}

extension DiaryTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.isFirstResponder, textView.text.prefix(4) == " 식후감" {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.isScrollEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "iconStar")
            attachment.bounds = CGRect(x: 6, y: 10, width: 6, height: 6)
            
            let attachmentStr = NSAttributedString(attachment: attachment)
            
            var placeHolder = NSMutableAttributedString()
            placeHolder = NSMutableAttributedString(string: " 식후감 ")
            placeHolder.append(attachmentStr)
            
            textView.attributedText = placeHolder
            textView.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.6)
            textView.font = UIFont(name: "HelveticaNeue", size: 16)
        }
    }
}
