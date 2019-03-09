//
//  View+Ext.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 2..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setOrangeUnderLine(alpha: CGFloat = 0.4) {
        let width = self.intrinsicContentSize.width + 5.0
        let underline = CALayer()
        underline.backgroundColor = UIColor.primaryOrange.withAlphaComponent(alpha).cgColor
        
        guard let superView = self.superview else { return }
        
        superView.layer.addSublayer(underline)
        underline.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height / 2, width: width, height: self.frame.size.height / 2)
        
        superView.bringSubviewToFront(self)
    }
    
    func changeLineSpacing(_ space: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
