import UIKit

class ScrollMonthCell: UICollectionViewCell {
    
    static let cellScrollMonth = "cellScrollMonth"
    
    var label: String? {
        didSet {
            if let label = label {
                titleLabel.text = label
            }
        }
    }
    
    let titleLabel: UILabel = {
        let titleLabel: UILabel = .textLabel(text: "MONTH", fontSize: 18, color: UIColor(named: K.colorText)!)
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.fill(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 6, left: 0, bottom: 0, right: 0)
        )
        
        titleLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
