//
//  WriteViewController.swift
//  MealDiary
//
//  Created by 박수현 on 16/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class WriteViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let completeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    func setUp() {
        self.titleLabel.setOrangeUnderLine()
        self.setNavigationBar()
        self.setTableView()
        self.completeButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
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
            diaryCell.setUp()
            
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
