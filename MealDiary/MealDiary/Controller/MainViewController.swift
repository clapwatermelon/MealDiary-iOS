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
    var headerView: MainHeaderView = MainHeaderView()
    var filterView: FilterView = FilterView()
    var cards: [Card] = sample.cards
    var selectedIndex: Set<Int> = []
    var tableFrame: CGRect?
    var filterFrame: CGRect?
    let headerViewHeight: CGFloat = 84
    
    var scrollViewStartOffsetY: CGFloat = 0
    var beforeOffsetY: CGFloat = 0
    
    func setFilterView() {
        guard let filterView = FilterView.instanceFromNib() else { return }
        self.filterView = filterView
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 50 + headerViewHeight)
        filterFrame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: 55))
        filterView.frame = filterFrame ?? CGRect(origin: .zero, size: .zero)
        
        self.view.addSubview(filterView)
    }
    
    func setInitialView() {
        guard let headerView = MainHeaderView.instanceFromNib() else { return }
        self.headerView = headerView
        
        headerView.writeButton.addTarget(self, action: #selector(tabWriteButton), for: .touchUpInside)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let origin = CGPoint(x: 0, y: statusBarHeight + 50)
        let headerFrame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: headerViewHeight))
        headerView.setUp(frame: headerFrame)
        
        self.view.addSubview(headerView)
        self.view.sendSubviewToBack(headerView)
        self.view.bringSubviewToFront(tableView)
    }
    
    func setTableView() {
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
    
    func setNavigationBar() {
        let size = navigationController!.navigationBar.frame.height
    
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(named: "iconIcSearchDefault")?.withRenderingMode(.alwaysOriginal), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(goSearchView), for: .touchUpInside)
        
        let widthConstraint = searchButton.widthAnchor.constraint(equalToConstant: size)
        let heightConstraint = searchButton.heightAnchor.constraint(equalToConstant: size)
        widthConstraint.isActive = true
        heightConstraint.isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
    
    @objc func goSearchView() {
        
    }
    
    @objc func tabWriteButton(sender: UIButton) {
        let storyBoard = UIStoryboard(name: "SelectPhoto", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectPhotoViewController") as! SelectPhotoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tabThreeDotsButton(sender: UIButton) {
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
        setInitialView()
        setFilterView()
        setTableView()
        setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY: CGFloat = {
            let firstOffset = scrollViewStartOffsetY < 0 ? scrollViewStartOffsetY * -1 : scrollViewStartOffsetY
            return scrollView.contentOffset.y + firstOffset
        }()
        
        guard let tableFrame = self.tableFrame else { return }
        guard let filterFrame = self.filterFrame else { return }
        
        let difference = offsetY - beforeOffsetY
        let height = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        
        if offsetY <= 0 {
            headerView.alpha = 1
            filterView.frame = filterFrame
            tableView.frame = tableFrame
        } else if offsetY >= (scrollView.contentSize.height - tableView.frame.height) {
            headerView.alpha = 0
        } else {
            if difference > 0 {
                if headerView.alpha > 0.0 {
                    headerView.alpha -= (difference / 80)
                }
                
                if tableView.frame.origin.y > height {
                    filterView.frame.origin.y -= difference
                    tableView.frame = CGRect(x: 0, y: tableView.frame.origin.y - difference, width: tableFrame.width, height: tableView.frame.size.height + difference)
                } else {
                    headerView.alpha = 0
                    filterView.frame = CGRect(x: 0, y: height - filterFrame.height, width: filterFrame.width, height: filterFrame.height)
                    tableView.frame = CGRect(x: 0, y: height, width: tableFrame.width, height: self.view.frame.height - height)
                }
                
            } else {
                if headerView.alpha < 1.0 {
                    headerView.alpha -= (difference / 150)
                }
                
                if filterView.frame.origin.y < filterFrame.origin.y {
                    filterView.frame.origin.y -= difference
                    tableView.frame = CGRect(x: 0, y: tableView.frame.origin.y - difference, width: tableFrame.width, height: tableView.frame.size.height + difference)
                } else {
                    headerView.alpha = 1
                    filterView.frame = filterFrame
                    tableView.frame = tableFrame
                }
                
            }
        }
        beforeOffsetY = offsetY
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
