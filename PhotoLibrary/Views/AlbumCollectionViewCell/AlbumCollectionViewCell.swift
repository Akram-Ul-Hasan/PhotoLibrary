//
//  AlbumCollectionViewCell.swift
//  PhotoLibrary
//
//  Created by Akram Ul Hasan on 18/4/24.
//

import UIKit
import Photos

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumThumbnail: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumPhotoTotal: UILabel!
        
    static public let className = String(describing: AlbumCollectionViewCell.self)
        
    static public func nib() -> UINib{
        return UINib(nibName: AlbumCollectionViewCell.className, bundle: nil)
    }
        
    public func configure( thumbnail: PHAsset?, title: String, count: Int, targetSize:CGSize) {
        albumTitle.text = title
        albumPhotoTotal.text = String(count)
        thumbnail?.getImage(targetSize: targetSize, completion: { image in
            self.albumThumbnail.image = image
        })
 

    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.albumThumbnail.contentMode = .scaleAspectFill
        self.albumThumbnail.layer.cornerRadius = 5
        self.albumThumbnail.clipsToBounds = true
    }
}
