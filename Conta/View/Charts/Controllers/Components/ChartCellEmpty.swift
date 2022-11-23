import Foundation
import UIKit

class ChartCellEmpty: UICollectionViewCell {
     
    static var chartCellEmpty = "chartCellEmpty"
    
    var title: String? {
        didSet {
            if let title = title {
                headerLabel.text = title
            }
        }
    }
    
    private lazy var headerStackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var clearButton: UIButton = {
        
        let button: UIButton = .roundedSymbolButton(
            symbolName: "clear",
            pointSize: 25,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorBG1)!,
            size: .init(width: 40, height: 40),
            cornerRadius: 20,
            ofSize: 10
        )
        return button
        
    }()
    
    private lazy var headerLabel: UILabel = {
        let headerLabel: UILabel = .textLabel(text: "home_title_page".localized(), fontSize: 18, color: .white, type: .Bold)
        return headerLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    func configView() {
        
        backgroundColor = UIColor(named: K.colorBG2)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        backgroundView = EmptyChartView()
                
        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(clearButton)
        
        addSubview(headerStackView)
        
        headerStackView.fill(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 20)
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
