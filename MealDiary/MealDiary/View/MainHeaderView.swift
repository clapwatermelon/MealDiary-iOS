//
//  MainHeaderView.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class MainHeaderView: UIView {
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    
    static let identifier = "MainHeaderView"
    
    class func instanceFromNib() -> MainHeaderView? {
        return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MainHeaderView
    }
    
    func setUp(frame: CGRect) {
        self.frame = frame
        writeButton.clipsToBounds = true
        writeButton.layer.cornerRadius = writeButton.frame.height / 2
    }
}
