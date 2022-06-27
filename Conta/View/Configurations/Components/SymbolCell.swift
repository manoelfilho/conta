import Foundation
import UIKit

import Foundation
import UIKit

class SymbolCell: UICollectionViewCell {
    
    static var cellCollectionSymbol = "cellCollectionSymbol"
    
    var symbolName: String? {
        didSet{
            uiImage.image = UIImage(systemName: symbolName ?? "star")
        }
    }
    
    private let uiImage: UIImageView = {
        let uiImage: UIImageView = UIImageView(image: UIImage(systemName: "star"))
        return uiImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: K.colorBG2)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(uiImage)
        uiImage.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        uiImage.tintColor = .white
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

