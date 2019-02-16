//
//  WriteViewController.swift
//  MealDiary
//
//  Created by 박수현 on 16/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit
import RxSwift

class WriteViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let completeButton = UIButton(type: .system)
    let disposeBag = DisposeBag()
    var cellHeight: CGFloat = 50
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    func setUp() {
        self.titleLabel.setOrangeUnderLine()
        self.setNavigationBar()
        self.setTableView()
        self.completeButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setTableView(){
        self.tableView.register(UINib(nibName: TitleTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TitleTableViewCell.identifier)
        self.tableView.register(UINib(nibName: DiaryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DiaryTableViewCell.identifier)
        self.tableView.register(UINib(nibName: TagTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TagTableViewCell.identifier)
        self.tableView.register(UINib(nibName: PlaceNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PlaceNameTableViewCell.identifier)
        
    }
    
    func setNavigationBar() {
        self.completeButton.setTitle("다음", for: .normal)
        self.completeButton.titleLabel?.font = UIFont(name: "SpoqaHanSans-Bold", size: 16)
        self.completeButton.tintColor = UIColor(red: 159/255, green: 164/255, blue: 165/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
        
    }
    
    @objc func tapCompleteButton(sender: UIButton) {
        let storyBoard = UIStoryboard(name: "SelectPhoto", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "SelectPhotoViewController") as? SelectPhotoViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 1 {
            return cellHeight
        }
        return 50
    }
}

extension WriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else {
                fatalError("Misconfigured cell type!")
            }
            titleCell.setUp()
            return titleCell
        } else if indexPath.row == 1 {
            guard let diaryCell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell", for: indexPath) as? DiaryTableViewCell else {
                fatalError("Misconfigured cell type!")
            }
            
            diaryCell.setUp(with: CGSize(width: view.frame.width, height: cellHeight + 20))
            diaryCell.contentHeightObservable.distinctUntilChanged()
                .subscribe( onNext: { [weak self] height in
                    self?.cellHeight = height + 20
//                    diaryCell.textView.frame = CGRect(x: 20, y: 12, width: (self?.view.frame.width ?? 40) - 40, height: (self?.cellHeight ?? 50) - 24)
//                    diaryCell.textView.isScrollEnabled = false
                    let fixedWidth = diaryCell.textView.frame.size.width
                    let newSize = diaryCell.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                    diaryCell.textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                    
                    diaryCell.bottomView.frame = CGRect(x: 20, y: (self?.cellHeight ?? 1) - 1, width: (self?.view.frame.width ?? 40) - 40, height: 1)
                    self?.tableView.reloadWithoutAnimation()
                    self?.view.layoutIfNeeded()
                    

                }).disposed(by: disposeBag)
            
            
            return diaryCell
        } else if indexPath.row == 2 {
            guard let tagCell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell else {
                fatalError("Misconfigured cell type!")
            }
            
            return tagCell
        } else {
            guard let placeNameCell = tableView.dequeueReusableCell(withIdentifier: "PlaceNameTableViewCell", for: indexPath) as? PlaceNameTableViewCell else {
                fatalError("Misconfigured cell type!")
            }
            
            //placeNameCell.placeNameTextField.text = "식당이름......."
            return placeNameCell
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
