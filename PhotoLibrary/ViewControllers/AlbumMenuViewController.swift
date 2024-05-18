import UIKit

class AlbumMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var optionTitles: [String] = []

//    weak var delegate: AlbumMenuDelegate?

    var isPresent: ((Bool) -> Void)?
    var selectedOption: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Album"
        view.backgroundColor = .white
        setupTableView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            isPresent?(true)
        }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        delegate?.didSelectAlbum(albumTitle: nil)
        isPresent?(false)
    }
    
    private func setupTableView() {
//        tableView.register("cell", forCellReuseIdentifier: "AlbumMenuViewController")
        tableView.dataSource = self
        tableView.delegate = self
            
    }
}

extension AlbumMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = optionTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAlbumTitle = optionTitles[indexPath.row]
        selectedOption?(selectedAlbumTitle)
//        delegate?.didSelectAlbum(albumTitle: selectedAlbumTitle)
        
        dismiss(animated: true, completion: nil)
            
    }
    
    
}

protocol AlbumMenuDelegate: AnyObject {
    func didSelectAlbum(albumTitle: String?)
}
