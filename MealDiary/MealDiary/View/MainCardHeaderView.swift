//
//  MainCardHeaderView.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class MainCardHeaderView: UITableViewHeaderFooterView {
    static let identifier = "MainCardHeaderView"
    
    class func instanceFromNib() -> MainCardHeaderView? {
        return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MainCardHeaderView
    }    
}
