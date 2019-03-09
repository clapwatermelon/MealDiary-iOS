//
//  DetailViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 3..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var card: BehaviorRelay<[ContentCard]?> = BehaviorRelay<[ContentCard]?>(value: nil)

    @objc func tabFeedMoreButton(sender: UIButton) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)

        let modifyActionButton = UIAlertAction(title: "수정", style: .default) { [weak self] action -> Void in
            let storyBoard = UIStoryboard(name: "Rate", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "SelectPhotoViewController") as? SelectPhotoViewController else {
                return
            }
            if let card = self?.card.value?.first {
                Global.shared.cardToModify = card
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheetController.addAction(modifyActionButton)

        let deleteActionButton = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action -> Void in
            if let card = self?.card.value?.first {
                Global.shared.delete(card: card)
            }
            self?.navigationController?.popToRootViewController(animated: true)
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func setUp(with card: ContentCard) {
        self.card.accept([card])
    }
    
    func setNavigationBar() {
        let size = navigationController!.navigationBar.frame.height
        
        let feedMoreButton = UIButton(type: .system)
        feedMoreButton.setImage(UIImage(named: "iconIcFeedMoreDefault")?.withRenderingMode(.alwaysOriginal), for: .normal)
        feedMoreButton.imageView?.contentMode = .scaleAspectFit
        feedMoreButton.addTarget(self, action: #selector(tabFeedMoreButton), for: .touchUpInside)
        feedMoreButton.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: feedMoreButton)
    }
    
    func setTableView() {
        tableView.register(UINib(nibName: DetailCardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DetailCardTableViewCell.identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        card.asObservable().flatMap { Observable.from(optional: $0) }
            .bind(to: tableView.rx.items(cellIdentifier: DetailCardTableViewCell.identifier, cellType: DetailCardTableViewCell.self)){
            (row, card, cell) in
            cell.setUp(with: card, parentViewSize: self.view.frame.size)
        }.disposed(by: disposeBag)
    }
    
    deinit {
        print("VC deinit")
    }
}

extension DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailCardTableViewCell.getHeight(for: card.value?[indexPath.item], parentViewSize: self.view.frame.size)
    }
}
