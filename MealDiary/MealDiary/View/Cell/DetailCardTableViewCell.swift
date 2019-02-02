//
//  MainCardTableViewCell.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class DetailCardTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var threeDotsButton: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var showHideButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    var card: Card?
    
    static let identifier = "DetailCardTableViewCell"
    let underlineAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor : UIColor.gray,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(with card: Card) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        cardNumberLabel.clipsToBounds = true
        cardNumberLabel.layer.cornerRadius = 10
        self.cardNumberLabel.text = "1/" + card.photos.count.description
        self.pointLabel.text = card.point.description + "점"
        self.restaurantNameLabel.text = card.restaurantName
        self.addressLabel.text = card.address
        self.card = card
        self.detailLabel.text = card.detailText
        addressLabel.attributedText = NSAttributedString(string: addressLabel.text ?? "", attributes: underlineAttributes)
        showHideButton.setAttributedTitle(NSAttributedString(string: "더보기", attributes: underlineAttributes), for: .normal)
    }
}

extension DetailCardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = card?.photos[indexPath.item]
        return cell
    }
}

extension DetailCardTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
