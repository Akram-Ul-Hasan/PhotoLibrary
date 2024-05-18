import UIKit
import Photos

class AllPhotosViewController: UIViewController/*, AlbumMenuDelegate*/ {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let photoManager = PhotoManager() 
    
    private var allPhotoAssets: [PHAsset] = []
    private var photoAssetToShow: [PHAsset] = []
    private var allAlbumAssetCollection: [PHAssetCollection] = []
    private var albumAssetCollectionToShow = PHAssetCollection()
    private var albumOptionTitles: [String] = []
    
    private var cellSize = CGFloat()
    
    private var titleLabel = UILabel()
    private var button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Photos"
        self.setupCollectionViewUI()
        self.setupTitleView()
        self.requestPhotoAuthorization()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.cellSize = collectionView.frame.width / 3
    }
    
    private func setupCollectionViewUI() {
        self.collectionView.register(CameraCollectionViewCell.nib(), forCellWithReuseIdentifier: CameraCollectionViewCell.className)
        self.collectionView.register( PhotosCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotosCollectionViewCell.className)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setupTitleView() {
        let titleView = createCustomTitleView()
        self.navigationItem.titleView = titleView
    }
    
    private func createCustomTitleView() -> UIView {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 44)) // Adjust width as needed

        // Title Label
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44)) // Adjust width as needed
        titleLabel.text = "All Photos"
        titleLabel.textAlignment = .center
        titleView.addSubview(titleLabel)

        // Button
        self.button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.addTarget(self, action: #selector(titleViewButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: titleLabel.frame.maxX + 10, y: 0, width: 44, height: 44) // Adjust position and size as needed
        titleView.addSubview(button)

        // Add Tap Gesture Recognizer to the titleView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleViewButtonTapped))
        titleView.addGestureRecognizer(tapGesture)

        return titleView
    }
    
    private func requestPhotoAuthorization() {
        photoManager.requestAuthorization { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.fetchPhotosAndAlbums()
            } else {
                print("Access to photo library denied.")
            }
        }
    }
    
    private func fetchPhotosAndAlbums() {
        photoManager.fetchAllPhotos { [weak self] photoAssets in
            guard let self = self else { return }
            if let photoAssets = photoAssets {
                self.allPhotoAssets = photoAssets
                self.photoAssetToShow = photoAssets
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                print("Failed to fetch photos.")
            }
        }
        
        photoManager.fetchAllAlbums { [weak self] albums in
            guard let self = self else { return }
            if let albums = albums {
                self.allAlbumAssetCollection = albums
                self.albumOptionTitles = ["All Photos"] + albums.compactMap { $0.localizedTitle }
            } else {
                print("Failed to fetch albums.")
            }
        }
    }
    
    
    
    
    
    
    
    
    @objc private func titleViewButtonTapped() {
        self.button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)

        guard let viewControllerToPresent = storyboard?.instantiateViewController(withIdentifier: "AlbumMenuViewController") as? AlbumMenuViewController else {
            return
        }
        
        viewControllerToPresent.isPresent = { [weak self] isPresented in
                DispatchQueue.main.async {
                    if isPresented {
                        self?.button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
                    } else {
                        self?.button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
                    }
                }
            }
        
        viewControllerToPresent.selectedOption = { [weak self] option in
            if !option.isEmpty {
                self?.albumPhotoToShowOnCollectionView(albumTitle: option)
            }
            
        }
        
        viewControllerToPresent.optionTitles = self.albumOptionTitles
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [ .medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
//            sheet.largestUndimmedDetentIdentifier = .medium
            
        }

//        viewControllerToPresent.delegate = self

        self.navigationController?.present(viewControllerToPresent, animated: true)
    }
    
    
    
    
    
    
    
    
//    func didSelectAlbum(albumTitle: String?) {
//        self.button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
//        if let title = albumTitle{
//            self.albumPhotoToShowOnCollectionView(albumTitle: title)
//        }
//    }
    
    func albumPhotoToShowOnCollectionView(albumTitle: String) {
        if albumTitle == "All Photos" {
            self.photoAssetToShow = self.allPhotoAssets
            self.titleLabel.text = "All Photos"

        } else {
            for album in allAlbumAssetCollection {
                if album.localizedTitle == albumTitle {
                    self.albumAssetCollectionToShow = album
                    break
                }
            }
            albumAssetCollectionToShow.getImagesFromSingleAlbum { photoAsset in
                self.photoAssetToShow = photoAsset
                self.titleLabel.text = albumTitle
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
//        self.title = albumTitle
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
  
}

//collectionview functions
extension AllPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoAssetToShow.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraCollectionViewCell.className, for: indexPath) as? CameraCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.className, for: indexPath) as? PhotosCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            let photoAsset = photoAssetToShow[indexPath.row - 1]

            cell.configure(asset: photoAsset, targetSize: CGSizeMake(self.cellSize, self.cellSize))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellSize, height: self.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let cameraCell = collectionView.cellForItem(at: indexPath) as? CameraCollectionViewCell {
                cameraCell.startCamera(withDelay: 0.0) // Start camera immediately
            }
            return
        }
        
        let selectedPhotoAsset = self.photoAssetToShow[indexPath.item - 1]
        
        guard let singlePhotoViewController = storyboard?.instantiateViewController(withIdentifier: "SinglePhotoViewController") as? SinglePhotoViewController else {
            return
        }
        
        singlePhotoViewController.selectedPhotoAsset = selectedPhotoAsset
        
        self.navigationController?.pushViewController(singlePhotoViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellIndexPath = IndexPath(row: 0, section: 0)
        guard let cameraCell = collectionView.cellForItem(at: cellIndexPath) as? CameraCollectionViewCell else {
            return
        }

        let cellRect = collectionView.convert(cameraCell.frame, to: collectionView.superview)
        let isIntersecting = collectionView.bounds.intersects(cellRect)

        if !isIntersecting{
            cameraCell.stopCamera()
        }
    }
    
}
