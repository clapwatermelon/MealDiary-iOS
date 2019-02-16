//
//  DiaryTableViewCell.swift
//  MealDiary
//
//  Created by 박수현 on 16/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiaryTableViewCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomView: UIView!
    static let identifier = "DiaryTableViewCell"
    let disposeBag = DisposeBag()
    let contentHeight: PublishSubject<CGFloat> = PublishSubject<CGFloat>()
    var contentHeightObservable: Observable<CGFloat> {
        return contentHeight.asObservable()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.rx.text.subscribe( onNext: { [weak self] text in
            self?.contentHeight.onNext(self?.textView.contentSize.height ?? 0)
        }).disposed(by: disposeBag)
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
    
    func setUp(with size: CGSize) {
        textView.frame = CGRect(x: 20, y: 12, width: size.width - 40, height: size.height - 24)
        bottomView.frame = CGRect(x: 20, y: textView.frame.height + 23, width: size.width - 40, height: 1)
        setUp()
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
