//
//  MainCardHeaderView.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class FilterView: UIView {
    static let identifier = "FilterView"
    
    class func instanceFromNib() -> FilterView? {
        return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? FilterView
    }    
}
