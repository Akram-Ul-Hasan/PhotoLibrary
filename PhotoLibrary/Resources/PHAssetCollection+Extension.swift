//
//  PHAssetCollection+Extension.swift
//  PhotoLibrary
//
//  Created by Akram Ul Hasan on 17/4/24.
//

import Photos
import UIKit

extension PHAssetCollection {
    
    func getImagesFromSingleAlbum( completion: @escaping ([PHAsset]) -> Void){
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(in: self, options: fetchOptions)
        
        var albumPhotos = [PHAsset]()
        
        assets.enumerateObjects { asset, _, _ in
            albumPhotos.append(asset)
        }
        
        completion(albumPhotos)
    }
    
    func getAlbumThumbnail(targetSize: CGSize,completion: @escaping (UIImage?) -> Void) {
        let fetchOptions = PHFetchOptions()
//        print(targetSize)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchOptions.fetchLimit = 1
            
        let assets = PHAsset.fetchAssets(in: self, options: fetchOptions)
//        print(assets.count)
            
        guard let lastAsset = assets.lastObject else {
            completion(nil)
            return
        }
            
        let imageManager = PHImageManager.default()
        imageManager.requestImage(for: lastAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
            completion(image)
        }
    }
    
    
}
