import Foundation
import UIKit

import Foundation
import UIKit

protocol SymbolCellProtocol {
    func didClickSymbol(symbol: String)
}

class SymbolCell: UICollectionViewCell {
    
    static var cellCollectionSymbol = "cellCollectionSymbol"
        
    var delegate: SymbolCellProtocol?
    
    var symbolName: String? {
        didSet{
            let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20), scale: .large)
            self.iconSymbolButton.setImage(UIImage(systemName: symbolName ?? "star", withConfiguration: config), for: .normal)
            self.iconSymbolButton.name = symbolName
        }
    }
    
    private var iconSymbolButton: CustomButton = {
        let button: CustomButton = .roundedSymbolButton(
            symbolName: "questionmark.diamond.fill",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorBG2)!,
            size: .init(width: 60, height: 60),
            cornerRadius: 15
        )
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: K.colorBG2)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        iconSymbolButton.addTarget(self, action: #selector(clickIcon), for: .touchUpInside)
        
        addSubview(iconSymbolButton)
        iconSymbolButton.centralizeSuperview()
        
    }
    
    @objc func clickIcon(sender:CustomButton){
        delegate?.didClickSymbol(symbol: sender.name ?? "questionmark.diamond.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

