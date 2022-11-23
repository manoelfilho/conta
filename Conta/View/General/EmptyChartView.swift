import Foundation
import UIKit

class EmptyChartView: UIView {
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        let label: UILabel = .textLabel(text: "without_chart_data".localized().uppercased(), fontSize: 15, color: UIColor(named: K.colorText)!)
        addSubview(label)
        label.centralizeSuperview()
    }
    
}
