import Foundation
import UIKit

struct AccountCellModel {
    let title: String?
    let color: String?
}

class AccountCell: UITableViewCell {
    
    static let cellAccount = "cellAccount"
    
    var accountCell: AccountCellModel? {
        didSet{
            self.titleLabel.text = accountCell?.title
            self.cellImage.backgroundColor = UIColor(hexString: (accountCell?.color)!)
        }
    }
    
    private let cellImage: UIView = {
        let cellImage = UIView()
        cellImage.size(size: .init(width: 30, height: 30))
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
        self.stackCell.addArrangedSubview(cellImage)
        self.stackCell.addArrangedSubview(titleLabel)
        addSubview(stackCell)
        stackCell.fillSuperview(padding: .init(top: 15, left: 20, bottom: 15, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
