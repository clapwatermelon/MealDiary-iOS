//
//  ViewController.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var headerView: MainHeaderView?
    var cards: [Card] = []
    var tableFrame: CGRect?
    var headerFrame: CGRect?
    let headerViewHeight: CGFloat = 84
    
    func setUpInitialView() {
        headerView = MainHeaderView.instanceFromNib()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 50)
        headerFrame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: headerViewHeight))
        headerView?.setUp(frame: headerFrame ?? CGRect(origin: .zero, size: .zero))
        
        guard let headerView = headerView else { return }
        self.view.addSubview(headerView)
    }
    
    func setUpTableView() {
        guard let headerView = MainHeaderView.instanceFromNib() else { return }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MainCardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MainCardTableViewCell.identifier)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 60 + headerView.frame.height)
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height - origin.y)
        tableFrame = CGRect(origin: origin, size: size)
        tableView.frame = tableFrame ?? CGRect(origin: .zero, size: .zero)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>){
        if velocity.y > 0 {
            // scroll down
            UIView.animate(withDuration: 0.3) {
                guard let tableFrame = self.tableFrame else { return }
                guard let headerFrame = self.headerFrame else { return }
                
                self.headerView?.alpha = 0
//                self.headerView?.frame = CGRect(x: 0, y: headerFrame.origin.y - self.headerViewHeight, width: headerFrame.width, height: headerFrame.height)
                self.tableView.frame = CGRect(x: 0, y: tableFrame.origin.y - self.headerViewHeight, width: tableFrame.size.width, height: tableFrame.size.height + self.headerViewHeight)
            }
            
        } else if velocity.y < 0 {
            // scroll up
            UIView.animate(withDuration: 0.3) {
                guard let tableFrame = self.tableFrame else { return }
                guard let headerFrame = self.headerFrame else { return }
                
                self.headerView?.alpha = 1
//                self.headerView?.frame = CGRect(x: 0, y: headerFrame.origin.y, width: headerFrame.width, height: headerFrame.height)
                self.tableView.frame = CGRect(x: 0, y: tableFrame.origin.y, width: tableFrame.size.width, height: tableFrame.size.height)
            }
        }
    }
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialView()
        setUpTableView()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cards.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainCardTableViewCell.identifier) as! MainCardTableViewCell
        cell.setUp()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        if let view = MainCardHeaderView.instanceFromNib() {
            headerView.addSubview(view)
        }
        headerView.backgroundColor = .white
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

