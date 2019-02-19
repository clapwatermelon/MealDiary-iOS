//
//  SearchViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 16..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    lazy private var searchBar: UISearchBar = UISearchBar()
    let disposeBag = DisposeBag()
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var tagHistoryTable: UITableView!
    var cards: BehaviorRelay<[ContentCard]> = BehaviorRelay<[ContentCard]>(value: [])
    var tagHistory: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: sample.tagHistory)
    var currentFilter = filterType.date
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var headLabel: UILabel!
    @IBAction func tabFilterButton(_ sender: Any) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let dateActionButton = UIAlertAction(title: "최신순", style: .default) { [weak self] action -> Void in
            guard let `self` = self else { return }
            self.currentFilter = filterType.date
            self.headLabel.text = filterType.date.rawValue
        }
        actionSheetController.addAction(dateActionButton)
        
        let distanceActionButton = UIAlertAction(title: "거리순", style: .default) { [weak self] action -> Void in
            guard let `self` = self else { return }
            self.currentFilter = filterType.distance
            self.headLabel.text = filterType.distance.rawValue
        }
        actionSheetController.addAction(distanceActionButton)
        
        let scoreActionButton = UIAlertAction(title: "평점순",style: .default) { [weak self] action -> Void in
            guard let `self` = self else { return }
            self.currentFilter = filterType.score
            self.headLabel.text = filterType.score.rawValue
        }
        actionSheetController.addAction(scoreActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func setSearchTable() {
//        searchTable.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        searchTable.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTable.rx.setDelegate(self).disposed(by: disposeBag)
        
        cards.asObservable().bind(to: searchTable.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)){
            (row, card, cell) in
            cell.setUp(with: card)
            }.disposed(by: disposeBag)
    }
    
    private func setHistoryTable() {
        tagHistoryTable.allowsSelection = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gesture.cancelsTouchesInView = false
        gesture.numberOfTapsRequired = 1
        tagHistoryTable.addGestureRecognizer(gesture)
        tagHistoryTable.register(UINib(nibName: TagHistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TagHistoryTableViewCell.identifier)
        tagHistoryTable.rx.setDelegate(self).disposed(by: disposeBag)
        
        tagHistory.asObservable().bind(to: tagHistoryTable.rx.items(cellIdentifier: TagHistoryTableViewCell.identifier, cellType: TagHistoryTableViewCell.self)){
            (row, tag, cell) in
            cell.tagLabel.text = tag
            }.disposed(by: disposeBag)
        
        tagHistoryTable.rx.itemSelected.subscribe( onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
            if let cell = self.tagHistoryTable.cellForRow(at: indexPath) as? TagHistoryTableViewCell {
                self.searchBar.text = cell.tagLabel.text
                self.searchTable.isHidden = false
                self.tagHistoryTable.isHidden = true
                self.filterButton.isHidden = false
                self.headLabel.font = UIFont.systemFont(ofSize: 17.0)
                self.headLabel.text = self.currentFilter.rawValue
            }
        }).disposed(by: disposeBag)
    }
    
    private func setSearchBar(){
        searchBar.sizeToFit()
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 8
        searchBar.placeholder = "태그, 제목 검색"
        navigationItem.titleView = searchBar
        searchBar.subviews.forEach{
            $0.subviews.forEach{
                if let textField = $0 as? UITextField {
                    textField.backgroundColor = UIColor.init(red: 243/255, green: 247/255, blue: 248/255, alpha: 1)
                }
            }
        }
        searchBar.rx.text.orEmpty // for not optional value
            .subscribe(onNext: { [weak self] query in
                guard let `self` = self else { return }
                if query.isEmpty {
                    self.searchTable.isHidden = true
                    self.tagHistoryTable.isHidden = false
                    self.filterButton.isHidden = true
                    self.headLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                    self.headLabel.text = "최근 검색 기록"
                } else {
                    self.searchTable.isHidden = false
                    self.tagHistoryTable.isHidden = true
                    self.filterButton.isHidden = false
                    self.headLabel.font = UIFont.systemFont(ofSize: 17.0)
                    self.headLabel.text = self.currentFilter.rawValue
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    deinit {
        print("VC deinit")
    }
}

extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setSearchTable()
        setHistoryTable()
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.searchTable {
           return 125
        } else {
            return 45
        }
    }
}
