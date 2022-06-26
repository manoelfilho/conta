import Foundation
import UIKit

struct CategoryCellModel {
    let title: String?
    let symbolName: String?
}

class CategoryCell: UITableViewCell {
    
    static let cellCategory = "cellCategory"
    
    var categoryCell: CategoryCellModel? {
        didSet{
            self.titleLabel.text = categoryCell?.title
            self.uiImageView.image = UIImage(systemName: (categoryCell?.symbolName)!)!
        }
    }
    
    private let uiImageView: UIImageView = {
        let image: UIImage = UIImage(systemName: "star")!
        let uiImageView: UIImageView = UIImageView(image: image)
        uiImageView.tintColor = UIColor(named: K.colorText)
        return uiImageView
    }()
    
    private let cellImage: UIView = {
        let cellImage = UIView()
        cellImage.size(size: .init(width: 40, height: 40))
        cellImage.layer.cornerRadius = 15
        return cellImage
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel: UILabel = .textLabel(
            text: "Account",
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
        self.backgroundColor = UIColor(named: K.colorBG2)
        self.accessoryType = .disclosureIndicator
        
        cellImage.addSubview(uiImageView)
        uiImageView.centralizeSuperview()
        
        self.stackCell.addArrangedSubview(cellImage)
        self.stackCell.addArrangedSubview(titleLabel)
        addSubview(stackCell)
        stackCell.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
