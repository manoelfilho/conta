import Foundation
import UIKit

struct ConfigCell {
    let title: String?
    let symbolName: String?
    let color: String?
}

class ConfigurationCell: UITableViewCell {
    
    static let cellConfiguration = "cellConfiguration"
    
    var configCell: ConfigCell? {
        didSet{
            self.iconImageCell.image = UIImage.init(systemName: configCell?.symbolName ?? "asterisk")
            self.titleLabel.text = configCell?.title
            self.iconImageCell.tintColor = .white
            self.cellImage.backgroundColor = UIColor(hexString: (configCell?.color)!)
        }
    }
    
    private let cellImage: UIView = {
        let cellImage = UIView()
        cellImage.size(size: .init(width: 30, height: 30))
        cellImage.layer.cornerRadius = 15
        return cellImage
    }()
        
    private let iconImageCell: UIImageView = {
        let iconImageCell: UIImage = UIImage(systemName: "plus")!
        let wrapperImage: UIImageView = UIImageView(image: iconImageCell)
        wrapperImage.size(size: .init(width: 15, height: 15))
        wrapperImage.tintColor = UIColor(named: K.colorText)!
        
        return wrapperImage
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel: UILabel = .textLabel(
            text: "Configuration",
            fontSize: 16,
            numberOfLines: 1,
            color: .white,
            type: .Regular
        )
        return titleLabel
    }()
    
    private let stackCell: UIStackView = {
        let stackCell: UIStackView = UIStackView()
        stackCell.axis = .horizontal
        stackCell.spacing = 20
        return stackCell
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: K.colorBG1)
        
        cellImage.addSubview(iconImageCell)
        iconImageCell.centralizeSuperview()
        
        self.stackCell.addArrangedSubview(cellImage)
        self.stackCell.addArrangedSubview(titleLabel)
                
        addSubview(stackCell)
        
        stackCell.fillSuperview(padding: .init(top: 15, left: 20, bottom: 15, right: 20))
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
