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
    
    func setUpInitialView() {
        guard let headerView = MainHeaderView.instanceFromNib() else { return }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 50)
        let frame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: 84))
        headerView.setUp(frame: frame)
        self.view.addSubview(headerView)
    }
    
    func setUpTableView() {
        guard let headerView = MainHeaderView.instanceFromNib() else { return }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MainCardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MainCardTableViewCell.identifier)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 60 + headerView.frame.height + 10)
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height - origin.y)
        tableView.frame = CGRect(origin: origin, size: size)
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
