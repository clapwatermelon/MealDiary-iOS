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
    var cards: BehaviorRelay<[Card]> = BehaviorRelay<[Card]>(value: sample.cards)
    
    private func setSearchTable() {
        searchTable.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTable.rx.setDelegate(self).disposed(by: disposeBag)
        
        cards.asObservable().bind(to: searchTable.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)){
            (row, card, cell) in
            cell.setUp(with: card)
            }.disposed(by: disposeBag)
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
                
            }).disposed(by: disposeBag)
    }
    
    @objc private func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}

extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setSearchTable()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
