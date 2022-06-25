import Foundation
import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "Hello".localized()
        
        view.addSubview(label)
        label.frame = view.bounds
        
        collectionView.backgroundColor = UIColor(named: K.colorBG2)
    }
}
