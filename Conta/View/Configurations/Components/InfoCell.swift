import Foundation
import UIKit

struct InfoCellStruct {
    let title: String?
}

class InfoCell: UITableViewCell {
    
    static let cellInfo = "cellInfo"
    
    var title: InfoCellStruct? {
        didSet{
            self.titleLabel.text = title?.title
        }
    }
        
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
        contentView.backgroundColor = UIColor(named: K.colorBG2)
        self.stackCell.addArrangedSubview(titleLabel)
        addSubview(stackCell)
        stackCell.fillSuperview(padding: .init(top: 15, left: 20, bottom: 15, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
