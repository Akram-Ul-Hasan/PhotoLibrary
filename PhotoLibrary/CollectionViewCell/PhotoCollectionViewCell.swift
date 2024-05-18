//
//  PhotoCollectionViewCell.swift
//  PhotoLibrary
//
//  Created by Akram Ul Hasan on 27/3/24.
//

import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumThumbnail: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    
    static public let className = String(describing: PhotoCollectionViewCell.self)
    
    static public func nib() -> UINib{
        return UINib(nibName: PhotoCollectionViewCell.className, bundle: nil)
    }
    
    public func configure( albumData: PHAssetCollection, targetSize:CGSize) {
        albumTitle.text = albumData.localizedTitle
//        albumData.getAlbumThumbnail(targetSize: targetSize) { thumbnail in
////            print(thumbnail?.size)
//        }
        self.albumThumbnail.image = /*thumbnail*/ UIImage(named: "jony")

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.albumThumbnail.layer.cornerRadius = 10
//        self.albumThumbnail.clipsToBounds = true
    }

}
