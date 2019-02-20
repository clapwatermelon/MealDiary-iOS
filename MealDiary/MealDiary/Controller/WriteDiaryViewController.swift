//
//  WriteDiaryViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 17..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var tableView = UITableView()
    private var searchedTagArray = [String]()
    private var hashTagArray = [String]()
    
    lazy var titleTextField = UITextField()
    lazy var textView = UITextView()
    lazy var hashTagTextField = UITextField()
    lazy var restaurantTextField = UITextField()
    
    lazy var bottomView1 = UIView()
    lazy var bottomView2 = UIView()
    lazy var bottomView3 = UIView()
    lazy var bottomView4 = UIView()
    lazy var textViewPlaceHolder = UILabel()
    
    var keyboardFrame = CGRect(origin: .zero, size: .zero)
    let completeButton = UIButton(type: .system)
    let disposeBag = DisposeBag()
    
    func adjustForKeyboard() {
        guard keyboardFrame.size != .zero else { return }
        
        if titleTextField.isFirstResponder {
            adjustFirstResponder(view: titleTextField)
        } else if textView.isFirstResponder {
            adjustFirstResponder(view: textView)
        } else if hashTagTextField.isFirstResponder {
            adjustFirstResponder(view: hashTagTextField)
        } else if restaurantTextField.isFirstResponder {
            adjustFirstResponder(view: restaurantTextField)
        }
        scrollView.isScrollEnabled = true
    }
    
    func adjustFirstResponder(view: UIView) {
        let scrollViewY = scrollView.frame.origin.y
        let viewEndY = scrollViewY + view.frame.origin.y + view.frame.size.height + 15
        let keyboardY = keyboardFrame.origin.y
        
        if viewEndY > keyboardY {
            let difference = keyboardY - viewEndY
            scrollView.contentSize.height += difference
            scrollView.contentOffset.y -= difference
        }
    }
    
    @objc func keyboardInteraction(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        keyboardFrame = keyboardViewEndFrame
        adjustForKeyboard()
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.isScrollEnabled = true
            scrollView.contentSize = CGSize(width: view.frame.width, height: bottomView4.frame.origin.y + 40)
        }
    }
    
    func setTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 400, width: self.view.frame.width, height: 48 * 5))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1)
        tableView.register(UINib(nibName: TagHistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TagHistoryTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    
    func setScrollView() {
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(textView)
        scrollView.addSubview(textViewPlaceHolder)
        scrollView.addSubview(hashTagTextField)
        scrollView.addSubview(restaurantTextField)
        scrollView.addSubview(bottomView1)
        scrollView.addSubview(bottomView2)
        scrollView.addSubview(bottomView3)
        scrollView.addSubview(bottomView4)
        
        titleTextField.delegate = self
        textView.delegate = self
        hashTagTextField.delegate = self
        restaurantTextField.delegate = self
        
        titleTextField.font = UIFont.systemFont(ofSize: 16.0)
        textView.font = UIFont.systemFont(ofSize: 16.0)
        hashTagTextField.font = UIFont.systemFont(ofSize: 16.0)
        restaurantTextField.font = UIFont.systemFont(ofSize: 16.0)
        textViewPlaceHolder.font = UIFont.systemFont(ofSize: 16.0)
        textViewPlaceHolder.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.6)
        
        titleTextField.clearButtonMode = .whileEditing
        hashTagTextField.clearButtonMode = .whileEditing
        restaurantTextField.clearButtonMode = .whileEditing
        
        bottomView2.backgroundColor = UIColor.paleGray
        bottomView3.backgroundColor = UIColor.paleGray
        bottomView4.backgroundColor = UIColor.paleGray
        
        setUpPlaceHolder()
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        titleTextField.frame = CGRect(x: 30, y: 0, width: view.frame.width - 60, height: 48)
        bottomView1.frame = CGRect(x: 20, y: titleTextField.frame.origin.y + titleTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        bottomView1.backgroundColor = UIColor.paleGray
        textViewPlaceHolder.frame = CGRect(x: 30, y: bottomView1.frame.origin.y + 5, width: 100, height: 48)
        
        adjustTextViewFrame()
    }
    
    func adjustTextViewFrame(with height: CGFloat = 36.0) {
        textView.frame = CGRect(x: 25, y: bottomView1.frame.origin.y + 5, width: view.frame.width - 50, height: height + 12)
        textView.contentInset.top = (textView.frame.height - textView.contentSize.height) / 2
        bottomView2.frame = CGRect(x: 20, y: textView.frame.origin.y + textView.frame.height, width: self.view.frame.width - 40, height: 1)
        
        hashTagTextField.frame = CGRect(x: 30, y: bottomView2.frame.origin.y + 5, width: view.frame.width - 60, height: 48)
        bottomView3.frame = CGRect(x: 20, y: hashTagTextField.frame.origin.y + hashTagTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        
        restaurantTextField.frame = CGRect(x: 30, y: bottomView3.frame.origin.y + 5, width: view.frame.width - 60, height: 48)
        bottomView4.frame = CGRect(x: 20, y: restaurantTextField.frame.origin.y + restaurantTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: bottomView4.frame.origin.y + 40)
        
        adjustForKeyboard()
        
        titleTextField.rx.text.subscribe(onNext: { [weak self] (text) in
            if !(text?.isEmpty ?? true) && !(self?.textView.text.isEmpty ?? true) {
                self?.enableCompletionButton()
            } else {
                self?.disableCompletionButton()
            }
        }).disposed(by: disposeBag)
    }
    
    func setTextView() {
        textView.rx.contentOffset
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] (offset) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.adjustTextViewFrame(with: self.textView.contentSize.height)
            }
        }).disposed(by: disposeBag)
        
        textView.rx.text
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] (text) in
                guard let `self` = self else { return }
                if self.textView.contentSize.height < (self.textView.frame.height - 12) {
                    DispatchQueue.main.async {
                        self.adjustTextViewFrame(with: self.textView.contentSize.height)
                    }
                }
                
                if text?.count ?? 0 > 0 {
                    self.textViewPlaceHolder.isHidden = true
                } else {
                    self.textViewPlaceHolder.isHidden = false
                }
                
                if !(self.titleTextField.text?.isEmpty ?? true) && !(text?.isEmpty ?? true) {
                    self.enableCompletionButton()
                } else {
                    self.disableCompletionButton()
                }
                
        }).disposed(by: disposeBag)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func enableCompletionButton() {
        self.completeButton.tintColor = .black
        self.completeButton.isEnabled = true
    }
    
    func disableCompletionButton() {
        self.completeButton.tintColor = UIColor(red: 159/255, green: 164/255, blue: 165/255, alpha: 1)
        self.completeButton.isEnabled = false
    }
    
    func setNavigationBar() {
        self.completeButton.setTitle("다음", for: .normal)
        self.completeButton.titleLabel?.font = UIFont(name: "SpoqaHanSans-Bold", size: 16)
        disableCompletionButton()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
        
        completeButton.rx.tap.subscribe( onNext: { [weak self] in
            guard let `self` = self else { return }
            let storyBoard = UIStoryboard(name: "Rate", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "RateViewController") as? RateViewController else {
                return
            }
            
            // To-do : 수현
            self.saveTag()
            
            Global.shared.titleText = self.titleTextField.text ?? ""
            Global.shared.detailText = self.textView.text
            Global.shared.hashTagList = self.hashTagArray
            Global.shared.restaurantName = self.restaurantTextField.text ?? ""
            Global.shared.restaurantLocation = ""
            Global.shared.restaurantLatitude = 0
            Global.shared.restaurantLongitude = 0
            //
            
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    func setUpPlaceHolder() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "iconStar")
        attachment.bounds = CGRect(x: 6, y: 10, width: 6, height: 6)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let placeHolder = NSMutableAttributedString(string: "제목")
        placeHolder.append(attachmentStr)
        
        let placeHolder_detail = NSMutableAttributedString(string: "식후감")
        placeHolder_detail.append(attachmentStr)
        textViewPlaceHolder.attributedText = placeHolder_detail
        
        titleTextField.attributedPlaceholder = placeHolder
        hashTagTextField.placeholder = "#태그"
        restaurantTextField.placeholder = "식당이름"
    }
    
    func searchTag(isTagWord: String) {
        if isTagWord.count < 1 {
            self.tableView.isHidden = true
            return
        }
        
        if isTagWord.prefix(1) != "#" {
            self.tableView.isHidden = true
        }
        
        if let tagArray = UserDefaults.standard.stringArray(forKey: "tag") {
            let tagWord = isTagWord.dropFirst()
            let filtered = tagArray.filter { $0.contains(tagWord) }
            
            self.searchedTagArray = filtered
            
            if filtered.count < 1 {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
            
            self.tableView.reloadData()
        }
    }
    
    func saveTag() {
        guard let hashTagTextField = self.hashTagTextField.text else {
            return
        }
        
        let tagWords = hashTagTextField.components(separatedBy: " ")
        self.hashTagArray = tagWords
        
        for tagWord in tagWords {
            if var tagArray = UserDefaults.standard.stringArray(forKey: "tag") {
                if !tagArray.contains(tagWord) {
                    tagArray.append(tagWord)
                    UserDefaults.standard.set(tagArray, forKey: "tag")
                }
            } else {
                var tagArray = [String]()
                tagArray.append(tagWord)
                UserDefaults.standard.set(tagArray, forKey: "tag")
            }
        }
    }
    
    deinit {
        print("VC deinit")
    }
}

extension WriteDiaryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.setOrangeUnderLine()
        setScrollView()
        setTextView()
        setTableView()
        setNavigationBar()
        
        if let card = Global.shared.cardToModify {
            titleTextField.text = card.titleText
            textView.text = card.detailText
            var hashTag = ""
            card.hashTagList.forEach { hashTag += ($0 + " ") }
            hashTagTextField.text = hashTag
            restaurantTextField.text = card.restaurantName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardInteraction(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardInteraction(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

extension WriteDiaryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleTextField {
            bottomView1.backgroundColor = UIColor.darkGray
        } else if textField == hashTagTextField {
            bottomView3.backgroundColor = UIColor.darkGray
        } else {
            bottomView4.backgroundColor = UIColor.darkGray
        }
        
        adjustForKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            bottomView1.backgroundColor = UIColor.paleGray
        } else if textField == hashTagTextField {
            bottomView3.backgroundColor = UIColor.paleGray
        } else {
            bottomView4.backgroundColor = UIColor.paleGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == hashTagTextField {
            if let text = textField.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                let words = updatedText.components(separatedBy: " ")
                for word in words {
                    searchTag(isTagWord: word)
                }
            }
        }
        
        return true
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        bottomView2.backgroundColor = UIColor.darkGray
        
        adjustForKeyboard()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        bottomView2.backgroundColor = UIColor.paleGray
    }
}

extension WriteDiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedTagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TagHistoryTableViewCell.identifier, for: indexPath) as? TagHistoryTableViewCell else {
            fatalError("Misconfigured cell type!")
        }
        
        cell.tagLabel.text = searchedTagArray[indexPath.row]
        
        return cell
    }
}

extension WriteDiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = self.tableView.cellForRow(at: indexPath) as? TagHistoryTableViewCell else {
//            fatalError("Misconfigured cell type!")
//        }
//
//        guard let hashTagTextField = self.hashTagTextField.text else {
//            return
//        }
//
//        if let selectedTagText = cell.tagLabel.text?.dropFirst() {
//            self.hashTagTextField.text = hashTagTextField + String(selectedTagText)
//        }
//    }
}
