//import UIKit
//import Photos
//
//class ViewController: UIViewController, AlbumMenuDelegate {
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    private let photoManager = PhotoManager.shared
//    
//    private var allAlbums = [PHAssetCollection]()
//    private var albumsToShow = [PHAssetCollection]()
//    private var optionTitles = ["All Albums"]
//
//    private var cellSize = CGFloat()
//    var isOpen = false
//    
//    var sideMenuWidth: CGFloat = UIScreen.main.bounds.width / 2 - 10
//    var sideMenuLeadingConstraint: NSLayoutConstraint!
//    lazy var sideMenuViewController: AlbumMenuViewController = {
//        let sideMenuVC = AlbumMenuViewController()
//        return sideMenuVC
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.title = "Albums"
//        
//        setupUI()
//        setupRightBarButton()
//        setupSideMenu()
//        
//        self.photoManager.fetchAllAlbums { allAlbums in
//            self.allAlbums = allAlbums
//            self.albumsToShow = self.allAlbums
//            
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//            
//            for album in self.allAlbums {
//                self.optionTitles.append(album.localizedTitle ?? "")
//            }
//            self.sideMenuViewController.optionTitles = self.optionTitles
//        }
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        cellSize = self.collectionView.frame.width / 2
//        
//    }
//    
//    func setupUI() {
//        collectionView.register(AlbumCollectionViewCell.nib(), forCellWithReuseIdentifier: AlbumCollectionViewCell.className)
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//    
//    func setupRightBarButton() {
//        let optionButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(optionBarButtonTapped))
//        navigationItem.rightBarButtonItem = optionButton
//    }
//    
//    func setupSideMenu() {
//        addChild(sideMenuViewController)
//        view.addSubview(sideMenuViewController.view)
//        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        sideMenuLeadingConstraint = sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: sideMenuWidth)
//        NSLayoutConstraint.activate([
//            sideMenuLeadingConstraint,
//            sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: sideMenuWidth)
//        ])
//        sideMenuViewController.didMove(toParent: self)
//        sideMenuViewController.delegate = self
//    }
//    
//    func albumToShowOnCollectionView(albumTitle: String) {
//        if albumTitle == "All Albums" {
//            self.albumsToShow = self.allAlbums
//        } else {
//            let filteredAlbums = self.allAlbums.filter { $0.localizedTitle == albumTitle }
//                self.albumsToShow = filteredAlbums
//        }
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//    }
//    
//    func didSelectAlbum(albumTitle: String) {
//        self.albumToShowOnCollectionView(albumTitle: albumTitle)
//        optionBarButtonTapped((Any).self)
//    }
//    
//    @objc func optionBarButtonTapped(_ sender: Any) {
////        
//        if isOpen == true{
//            sideMenuLeadingConstraint.constant = 0
//        } else {
//            sideMenuLeadingConstraint.constant = -sideMenuWidth
//        }
//        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
////            self.navigationItem.rightBarButtonItem?.image = self.isOpen == true ? UIImage(named: "dots") :
//            
//            if self.isOpen == true {
//                self.navigationItem.rightBarButtonItem?.title = "Select"
//            } else {
//                self.navigationItem.rightBarButtonItem?.title = "Cancel"
//            }
//        }
//        
//        self.isOpen = !self.isOpen
//    }
//}
//
////UICollectionView functions
//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return self.albumsToShow.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.className, for: indexPath) as? AlbumCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        
//        let selectedAlbum = albumsToShow[indexPath.row]
//        let fetchedAssets = PHAsset.fetchAssets(in: selectedAlbum, options: nil)
//        let  coverAsset = fetchedAssets.firstObject
//        cell.configure(thumbnail: coverAsset, title: selectedAlbum.localizedTitle ?? "", count: fetchedAssets.count, targetSize: CGSizeMake(self.cellSize, self.cellSize))
//        return cell
//    }
//  
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.cellSize, height: self.cellSize+40)
//    }
//    
//    func collectionView(_ : UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let albumPhotosViewController = storyboard?.instantiateViewController(withIdentifier: "AlbumPhotosViewController") as? AlbumPhotosViewController else {
//            return
//        }
//
//        let selectedAlbum = self.albumsToShow[indexPath.row]
//        albumPhotosViewController.selectedAlbum = selectedAlbum
//    
//        navigationController?.pushViewController(albumPhotosViewController, animated: true)
//    }
//    
//}
