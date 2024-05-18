import UIKit
import Photos

class SinglePhotoViewController: UIViewController {

    @IBOutlet weak var singleImage: UIImageView!
    var selectedPhotoAsset = PHAsset()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        selectedPhotoAsset.getImage(targetSize: CGSizeMake(singleImage.frame.width, singleImage.frame.height)){ photo in
            self.singleImage.image = photo
        }
    }
}
