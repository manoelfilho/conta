import Foundation
import UIKit

class TransactionCell: UITableViewCell {
    
    static let cellTransaction = "cellTransaction"
        
    var transaction: Transaction? {
        didSet{
            if let transaction = transaction {
                
                let formatterDate = DateFormatter()
                formatterDate.dateStyle = .medium
                
                let formatterNumber = NumberFormatter()
                formatterNumber.locale = Locale.current
                formatterNumber.numberStyle = .currency
                
                let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20), scale: .large)
                self.iconButtonCell.setImage(UIImage(systemName: transaction.category?.symbolName ?? "star", withConfiguration: config), for: .normal)
                
                self.titleLabel.text = transaction.title
                self.dataLabel.text = formatterDate.string(from: transaction.date ?? Date.now)
                self.valueLabel.text = formatterNumber.string(from: NSNumber(value: transaction.value))
                self.accountMarker.backgroundColor = UIColor(hexString: transaction.account?.color ?? "#FFFFFF")
                self.accountLabel.text = transaction.account?.title
            }
        }
    }
    
    private var iconButtonCell: UIButton = {
        let iconImageCell: UIButton = .roundedSymbolButton(
            symbolName: "star",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorBG2)!,
            size: .init(width: 60, height: 60),
            cornerRadius: 30
        )
        iconImageCell.tintColor = UIColor(named: K.colorText)
        return iconImageCell
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel: UILabel = .textLabel(
            text: "Transaction",
            fontSize: 16,
            numberOfLines: 1,
            color: .white,
            type: .Bold
        )
        return titleLabel
    }()
    
    private let dataLabel: UILabel = {
        let dataLabel: UILabel = .textLabel(
            text: "Data",
            fontSize: 15,
            numberOfLines: 1,
            color: UIColor(named: K.colorText)!,
            type: .Regular
        )
        return dataLabel
    }()
    
    private let accountMarker: UIView = {
        let accountMarker: UIView = UIView()
        accountMarker.size(size: .init(width: 12, height: 12))
        accountMarker.layer.cornerRadius = 6
        return accountMarker
    }()
    
    private let accountLabel: UILabel = {
        let accountLabel: UILabel = .textLabel(
            text: "Account",
            fontSize: 13,
            numberOfLines: 1,
            color: UIColor(named: K.colorText)!,
            type: .Regular
        )
        return accountLabel
    }()
    
    private let valueLabel: UILabel = {
        let valueLabel: UILabel = .textLabel(
            text: "$00,00",
            fontSize: 15,
            numberOfLines: 1,
            color: UIColor(named: K.colorText)!,
            type: .Regular
        )
        valueLabel.textAlignment = .right
        return valueLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: K.colorBG1)
        
        let cellImage = UIView()
        cellImage.size(size: .init(width: 60, height: 60))
        cellImage.backgroundColor = UIColor(named: K.colorBG2)
        cellImage.addSubview(iconButtonCell)
        cellImage.layer.cornerRadius = 30
        
        let stackAccountLabel = UIStackView(arrangedSubviews: [accountMarker, accountLabel])
        stackAccountLabel.spacing = 10
        
        let stackDescription = UIStackView(arrangedSubviews: [titleLabel, dataLabel, stackAccountLabel])
        stackDescription.axis = .vertical
        stackDescription.alignment = .leading
        stackDescription.distribution = .equalCentering
        
        let stackViewCell = UIStackView(arrangedSubviews: [cellImage, stackDescription, valueLabel])
        contentView.addSubview(stackViewCell)
        stackViewCell.spacing = 10
                        
        stackViewCell.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
