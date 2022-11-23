import Foundation
import UIKit

class HeaderChartsController: UICollectionReusableView {
    
    static var homeHeaderCell = "homeHeaderCell"
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        headerView.backgroundColor = UIColor(named: K.colorBG1)
        let headerStackView = UIStackView()
        let nameAndDescriptionStack = UIStackView()
        let nameLabel: UILabel = .textLabel(text: "chart_title_page".localized(), fontSize: 30, color: .white, type: .Semibold)
        let descriptionLabel: UILabel = .textLabel(text: "chart_description_page".localized(), fontSize: 15, color: .white, type: .Regular)
        nameAndDescriptionStack.addArrangedSubview(nameLabel)
        nameAndDescriptionStack.addArrangedSubview(descriptionLabel)
        nameAndDescriptionStack.axis = .vertical
        headerStackView.addArrangedSubview(nameAndDescriptionStack)
        headerView.addSubview(headerStackView)
        headerStackView.distribution = .equalCentering
        headerStackView.alignment = .center
        headerStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        return headerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
        headerView.fillSuperview()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
