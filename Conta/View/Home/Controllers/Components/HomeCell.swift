import Foundation
import UIKit

class HomeCell: UICollectionViewCell {
    
    static var cellCollectionViewHome = "cellCollectionViewHome"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
