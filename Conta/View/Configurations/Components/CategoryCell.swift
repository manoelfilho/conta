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
            let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20), scale: .large)
            self.iconButtonCell.setImage(UIImage(systemName: categoryCell?.symbolName ?? "star", withConfiguration: config), for: .normal)
        }
    }
    
    private var iconButtonCell: UIButton = {
        let iconImageCell: UIButton = .roundedSymbolButton(
            symbolName: "star",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorBG2)!,
            size: .init(width: 30, height: 30),
            cornerRadius: 30
        )
        return iconImageCell
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
        
        self.stackCell.addArrangedSubview(iconButtonCell)
        self.stackCell.addArrangedSubview(titleLabel)
        addSubview(stackCell)
        stackCell.fillSuperview(padding: .init(top: 15, left: 20, bottom: 15, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
