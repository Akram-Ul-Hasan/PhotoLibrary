//
//  AlbumPhotoCollectionViewCell.swift
//  PhotoLibrary
//
//  Created by Akram Ul Hasan on 3/4/24.
//

import UIKit
import Photos

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var singleImage: UIImageView!
    
    static var className = String(describing: PhotosCollectionViewCell.self)
    static func nib() -> UINib{
        return UINib(nibName: PhotosCollectionViewCell.className, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        singleImage.layer.cornerRadius = 2
        singleImage.clipsToBounds = true
    }
    
    public func configure( asset: PHAsset?, targetSize: CGSize) {
        asset?.getImage(targetSize: targetSize, completion: { photo in
            self.singleImage.image = photo
        })
    }

}
