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
    var filterView: MainCardHeaderView?
    var cards: [Card] = sample.cards
    var selectedIndex: Set<Int> = []
    var tableFrame: CGRect?
    var filterFrame: CGRect?
    let headerViewHeight: CGFloat = 84
    
    func setFilterView() {
        guard let filterView = MainCardHeaderView.instanceFromNib() else { return }
        self.filterView = filterView
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 50 + headerViewHeight)
        filterFrame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: 45))
        filterView.frame = filterFrame ?? CGRect(origin: .zero, size: .zero)
        
        self.view.addSubview(filterView)
    }
    
    func setUpInitialView() {
        guard let headerView = MainHeaderView.instanceFromNib() else { return }
        self.headerView = headerView
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 50)
        let headerFrame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: headerViewHeight))
        headerView.setUp(frame: headerFrame)
        
        self.view.addSubview(headerView)
    }
    
    func setUpTableView() {
        guard let headerView = MainHeaderView.instanceFromNib() else { return }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MainCardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MainCardTableViewCell.identifier)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 105 + headerView.frame.height)
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height - origin.y)
        tableFrame = CGRect(origin: origin, size: size)
        tableView.frame = tableFrame ?? CGRect(origin: .zero, size: .zero)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>){
        if velocity.y > 0 {
            // scroll down
            UIView.animate(withDuration: 0.2) {
                guard let tableFrame = self.tableFrame else { return }
                guard let filterFrame = self.filterFrame else { return }
                
                self.headerView?.alpha = 0
                self.filterView?.frame = CGRect(x: 0, y: filterFrame.origin.y - self.headerViewHeight, width: filterFrame.size.width, height: filterFrame.size.height)
                self.tableView.frame = CGRect(x: 0, y: tableFrame.origin.y - self.headerViewHeight, width: tableFrame.size.width, height: tableFrame.size.height + self.headerViewHeight)
            }
            
        } else if velocity.y < 0 {
            // scroll up
            UIView.animate(withDuration: 0.2) {
                guard let tableFrame = self.tableFrame else { return }
                guard let filterFrame = self.filterFrame else { return }
                
                self.headerView?.alpha = 1
                self.filterView?.frame = CGRect(x: 0, y: filterFrame.origin.y, width: filterFrame.size.width, height: filterFrame.size.height)
                self.tableView.frame = CGRect(x: 0, y: tableFrame.origin.y, width: tableFrame.size.width, height: tableFrame.size.height)
            }
        }
    }
    
    @objc func tabThreeDotsButton(sender: UIButton){
//        let buttonTag = sender.tag
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let modifyActionButton = UIAlertAction(title: "수정", style: .default) { action -> Void in
            print("수정")
        }
        actionSheetController.addAction(modifyActionButton)
        
        let deleteActionButton = UIAlertAction(title: "삭제", style: .destructive) { action -> Void in
            print("삭제")
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func tabShowHideButton(sender: UIButton) {
        let buttonTag = sender.tag
        let underlineAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        if selectedIndex.contains(buttonTag) {
            selectedIndex.remove(buttonTag)
            sender.setAttributedTitle(NSAttributedString(string: "더보기", attributes: underlineAttributes), for: .normal)
        } else {
            selectedIndex.insert(buttonTag)
            sender.setAttributedTitle(NSAttributedString(string: "접기", attributes: underlineAttributes), for: .normal)
        }
        tableView.reloadWithoutAnimation()
    }
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialView()
        setFilterView()
        setUpTableView()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainCardTableViewCell.identifier) as! MainCardTableViewCell
        cell.setUp(with: cards[indexPath.item])
        cell.threeDotsButton.addTarget(self, action: #selector(tabThreeDotsButton), for: .touchUpInside)
        cell.showHideButton.addTarget(self, action: #selector(tabShowHideButton), for: .touchUpInside)
        cell.threeDotsButton.tag = indexPath.item
        cell.showHideButton.tag = indexPath.item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex.contains(indexPath.item) {
            return 800
        } else {
            return 500
        }
    }
}

extension UITableView {
    func reloadWithoutAnimation() {
        let lastScrollOffset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }
}
