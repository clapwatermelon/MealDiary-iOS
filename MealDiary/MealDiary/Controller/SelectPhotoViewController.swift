//
//  SelectPhotoViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 1. 26..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

class SelectPhotoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: BehaviorRelay<[Any]> = BehaviorRelay<[Any]>(value: [])
    var selectedIndexPaths: BehaviorRelay<[IndexPath]> = BehaviorRelay<[IndexPath]>(value: [])
    var dictionary: [Int: Int] = [:]
    let nextButton = UIButton(type: .system)
    var disposeBag = DisposeBag()
    
//    func checkUncheckCell(for indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell {
//            if cell.checked {
//
//                var selectedIndexPathsValue = self.selectedIndexPaths.value
//                selectedIndexPathsValue.append(indexPath)
//                selectedIndexPaths.accept(selectedIndexPathsValue)
//
//                if selectedIndexPathsValue.count != 0 {
//                    nextButton.isEnabled = true
//                }
//
//            } else {
//                var selectedIndexPathsValue = self.selectedIndexPaths.value
//
//                guard let index = selectedIndexPathsValue.firstIndex(of: indexPath) else { return }
//                selectedIndexPathsValue.remove(at: index)
//                self.selectedIndexPaths.accept(selectedIndexPathsValue)
//
//                if selectedIndexPathsValue.count == 0 {
//                    self.nextButton.isEnabled = false
//                }
//
//                cell.uncheck()
//            }
//        }
//    }
    
    func setCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: SelectPhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SelectPhotoCollectionViewCell.identifier)
        
        photos.asObservable().bind(to: collectionView.rx.items(cellIdentifier: SelectPhotoCollectionViewCell.identifier, cellType: SelectPhotoCollectionViewCell.self)){
            [weak self] (item, photo, cell) in
            guard let `self` = self else { return }

            cell.index = self.dictionary[item] ?? 0
            
            if let photoAsset = photo as? PHAsset {
                cell.setUp(with: photoAsset)
            } else if let photoData = photo as? Data {
                cell.setUp(with: photoData)
                let indexPath = IndexPath(item: item, section: 0)
                var paths = self.selectedIndexPaths.value
                paths.append(indexPath)
                self.selectedIndexPaths.accept(paths)
                
                let index = paths.firstIndex(of: indexPath) ?? 0
                self.dictionary[indexPath.item] = index + 1
                cell.check(index: index + 1)
            }
            
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                
                if cell.checked {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    
                    guard let index = selectedIndexPaths.firstIndex(of: indexPath) else { return }
                    selectedIndexPaths.remove(at: index)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count == 0 {
                        self.nextButton.isEnabled = false
                    }
                    
                    cell.uncheck()
                } else {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    selectedIndexPaths.append(indexPath)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count != 0 {
                        self.nextButton.isEnabled = true
                    }
                }
                
                
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                
                if cell.checked {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    
                    guard let index = selectedIndexPaths.firstIndex(of: indexPath) else { return }
                    selectedIndexPaths.remove(at: index)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count == 0 {
                        self.nextButton.isEnabled = false
                    }
                    
                    cell.uncheck()
                } else {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    selectedIndexPaths.append(indexPath)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count != 0 {
                        self.nextButton.isEnabled = true
                    }
                }
                
                
            }).disposed(by: disposeBag)

        selectedIndexPaths.asObservable().subscribe(onNext: { [weak self] indexPaths in
            indexPaths.forEach({ [weak self] (indexPath) in
                guard let `self` = self else { return }
                guard let index = indexPaths.firstIndex(of: indexPath) else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                
                self.dictionary[indexPath.item] = index + 1
                cell.check(index: index + 1)
            })
        }).disposed(by: disposeBag)
    }
    
    func getImages (){
        var array: [Any] = AssetManager.fetchImages(by: nil)
        if let card = Global.shared.cardToModify {
            array = (card.photoDatas as [Any]) + array
        }
        photos.accept(array)
        
//        DispatchQueue.main.async { [weak self] in
//            self?.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
//            self?.collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: false, scrollPosition: .top)
//        }
        
    }
    
    func setNavigationBar() {
        nextButton.setTitle("다음", for: .normal)
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            nextButton.titleLabel?.font = font
        }
        nextButton.addTarget(self, action: #selector(completeSelect), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        nextButton.isEnabled = false
    }
    
    @objc func completeSelect() {
        var datas: [Data] = []
        for index in selectedIndexPaths.value {
            if let cell = collectionView.cellForItem(at: index) as? SelectPhotoCollectionViewCell {
                if let data = cell.data {
                    datas.append(data)
                } else if let data = cell.imageView.image?.pngData() {
                    datas.append(data)
                    
                }
            }
        }
        
        Global.shared.photoDatas = datas
        
        let storyBoard = UIStoryboard(name: "Write", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else {
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    public var topDistance : CGFloat{
//        get{
//            if navigationController != nil && !navigationController!.navigationBar.isTranslucent{
//                return 0
//            }else{
//                let barHeight = navigationController?.navigationBar.frame.height ?? 0
//                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
//                return barHeight + statusBarHeight
//            }
//        }
//    }
    
    deinit {
        print("VC deinit")
        disposeBag = DisposeBag()
    }
}

extension SelectPhotoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setNavigationBar()
        PHPhotoLibrary.requestAuthorization({ [weak self]
            (newStatus) in
            if newStatus ==  PHAuthorizationStatus.authorized {
                self?.getImages()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        titleLabel.setOrangeUnderLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension SelectPhotoViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        getImages()
    }
}


extension SelectPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 3) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
