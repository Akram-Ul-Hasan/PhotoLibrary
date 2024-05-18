import UIKit
import Photos

class AlbumPhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedAlbum: PHAssetCollection?
    var cellSize = CGFloat()
    var albumPhotos = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedAlbum?.localizedTitle

        setupUI()
        
        selectedAlbum?.getImagesFromSingleAlbum(completion: { photos in
            self.albumPhotos = photos
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cellSize = collectionView.frame.width / 3 
    }
   
    func setupUI(){
        
        collectionView.register(PhotosCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotosCollectionViewCell.className)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//UiCollectionView Functions for AlbumPhotosViewController
extension AlbumPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.className, for: indexPath) as? PhotosCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let albumSinglePhoto = self.albumPhotos[indexPath.row]
        
        cell.configure(asset: albumSinglePhoto, targetSize: CGSizeMake(cellSize, cellSize))
      
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellSize, height: cellSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhotoAsset = self.albumPhotos[indexPath.item]
        
        guard let singlePhotoViewController = storyboard?.instantiateViewController(withIdentifier: "SinglePhotoViewController") as? SinglePhotoViewController else {
            return
        }
        
        singlePhotoViewController.selectedPhotoAsset = selectedPhotoAsset
        
        self.navigationController?.pushViewController(singlePhotoViewController, animated: true)

    }
}
