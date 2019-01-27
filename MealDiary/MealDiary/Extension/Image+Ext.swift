//
//  Image+Ext.swift
//  MealDiary
//
//  Created by mac on 2019. 1. 26..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import Photos

extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: { (image : UIImage?, _) in
            guard let image = image else { return }
            
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            }
            
            self.image = image
        })
        
//        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
//            guard let image = image else { return }
//            switch contentMode {
//            case .aspectFill:
//                self.contentMode = .scaleAspectFill
//            case .aspectFit:
//                self.contentMode = .scaleAspectFit
//            }
//            self.image = image
//        }
        
    }
}
