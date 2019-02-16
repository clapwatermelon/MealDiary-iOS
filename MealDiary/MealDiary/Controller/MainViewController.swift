//
//  ViewController.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum filterType: String {
    case date = "최신순"
    case distance = "거리순"
    case score = "평점순"
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var headerView: MainHeaderView = MainHeaderView()
    var filterView: FilterView = FilterView()
    var cards: BehaviorRelay<[Card]> = BehaviorRelay<[Card]>(value: sample.cards)
    var selectedIndex: Set<Int> = []
    var tableFrame: CGRect?
    var filterFrame: CGRect?
    
    var scrollViewStartOffsetY: CGFloat = 0
    var beforeOffsetY: CGFloat = 0
    var height: CGFloat = 0
    let disposeBag = DisposeBag()
    
    func setFilterView() {
        guard let filterView = FilterView.instanceFromNib() else { return }
        self.filterView = filterView
      
        let origin = CGPoint(x: 0, y: height + headerView.frame.height)
        let filterFrame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: 55))
        filterView.setUp(frame: filterFrame)
        
        self.filterFrame = filterFrame
        self.view.addSubview(filterView)
        
        filterView.filterButton.rx.tap.bind{ [weak self] in
            guard let `self` = self else { return }
            self.tabFilterButton()
        }.disposed(by: disposeBag)
    }
    
    func tabFilterButton() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let dateActionButton = UIAlertAction(title: "최신순", style: .default) { [weak self] action -> Void in
            guard let `self` = self else { return }
            self.filterView.filterLabel.text = filterType.date.rawValue
        }
        actionSheetController.addAction(dateActionButton)
        
        let distanceActionButton = UIAlertAction(title: "거리순", style: .default) { [weak self] action -> Void in
            guard let `self` = self else { return }
            self.filterView.filterLabel.text = filterType.distance.rawValue
        }
        actionSheetController.addAction(distanceActionButton)
        
        let scoreActionButton = UIAlertAction(title: "평점순",style: .default) { [weak self] action -> Void in
            guard let `self` = self else { return }
            self.filterView.filterLabel.text = filterType.score.rawValue
        }
        actionSheetController.addAction(scoreActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func setInitialView() {
        guard let headerView = MainHeaderView.instanceFromNib() else { return }
        guard let `navigationController` = navigationController else { return }
        
        height = UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.height
        self.headerView = headerView
        
        headerView.writeButton.addTarget(self, action: #selector(tabWriteButton), for: .touchUpInside)
        let origin = CGPoint(x: 0, y: height)
        let headerFrame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: 94))
        headerView.setUp(frame: headerFrame)
        
        self.view.addSubview(headerView)
        self.view.sendSubviewToBack(headerView)
        self.view.bringSubviewToFront(tableView)
    }
    
    func setTableView() {
        tableView.register(UINib(nibName: HomeCardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeCardTableViewCell.identifier)
        let origin = CGPoint(x: 0, y: filterView.frame.origin.y + filterView.frame.height)
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height - origin.y)
        tableFrame = CGRect(origin: origin, size: size)
        tableView.frame = tableFrame ?? CGRect(origin: .zero, size: .zero)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        cards.asObservable().bind(to: tableView.rx.items(cellIdentifier: HomeCardTableViewCell.identifier, cellType: HomeCardTableViewCell.self)){
            (row, card, cell) in
            cell.setUp(with: card)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe( onNext: { [weak self] (indexPath) in
            guard let `self` = self else { return }
            let card = self.cards.value[indexPath.item]
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.setUp(with: card)
            
        }).disposed(by: disposeBag)
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
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tabWriteButton(sender: UIButton) {
//        let storyBoard = UIStoryboard(name: "Rate", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
        let storyBoard = UIStoryboard(name: "Write", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popUpSplash() {
        let storyBoard = UIStoryboard(name: "Splash", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SplashNavigation") as! SplashNavigation
        self.present(vc, animated: true, completion: nil)
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

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 387
    }
}
