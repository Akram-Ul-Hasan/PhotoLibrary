//
//  PHAsset+Extension.swift
//  PhotoLibrary
//
//  Created by Akram Ul Hasan on 16/4/24.
//

import Photos
import UIKit

extension PHAsset {
    
    func getImage(targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: self, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
            completion(image)
        }
    }
    
}
