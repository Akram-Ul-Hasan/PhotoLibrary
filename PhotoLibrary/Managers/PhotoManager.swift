import Photos

protocol PhotoFetching {
    func fetchAllPhotos(completion: @escaping ([PHAsset]?) -> Void)
    func fetchAllAlbums(completion: @escaping ([PHAssetCollection]?) -> Void)
    func requestAuthorization(completion: @escaping (Bool) -> Void)

}

class PhotoManager: PhotoFetching {
    
    func fetchAllPhotos(completion: @escaping ([PHAsset]?) -> Void) {
        
        let allPhotosOption = PHFetchOptions()
        allPhotosOption.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotosOption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let fetchedAllPhotoAsset = PHAsset.fetchAssets(with: allPhotosOption)
        
        var allAssetArray: [PHAsset] = []
        fetchedAllPhotoAsset.enumerateObjects { asset, _, _ in
            allAssetArray.append(asset)
        }
        completion(allAssetArray)
    }
    
    func fetchAllAlbums(completion: @escaping ([PHAssetCollection]?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)

        let regularAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

        var allAlbumsArray: [PHAssetCollection] = []
            
        smartAlbums.enumerateObjects { collection, _, _ in
            let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            if assets.count > 0 {
                allAlbumsArray.append(collection)
            }
        }
            
        regularAlbums.enumerateObjects { collection, _, _ in
            allAlbumsArray.append(collection)
        }
        
        completion( allAlbumsArray)
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }
}
