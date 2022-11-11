import Foundation
import UIKit
import Charts

class HomeCell: UICollectionViewCell, ChartViewDelegate {
    
    static var homeCell = "homeCell"
    
    private lazy var headerLabel: UILabel = {
        let headerLabel: UILabel = .textLabel(text: "home_title_page".localized(), fontSize: 15, color: .white, type: .Bold)
        return headerLabel
    }()
    
    var chartView: LineChartView = {
        var lineChartView = LineChartView()
        
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.animate(xAxisDuration: 0.5)
        lineChartView.xAxis.enabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        return lineChartView
        
    }()
    
    let customMarkerView = CustomMarkerView()
    
    var yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 1.0, y: 8.0),
        ChartDataEntry(x: 2.0, y: 2.0),
        ChartDataEntry(x: 3.0, y: 8.0),
        ChartDataEntry(x: 4.0, y: 2.0),
        ChartDataEntry(x: 5.0, y: 8.0),
        ChartDataEntry(x: 6.0, y: 2.0)
    ]
    
    var yValues2: [ChartDataEntry] = [
        ChartDataEntry(x: 1.0, y: 10.0),
        ChartDataEntry(x: 2.0, y: 1.0),
        ChartDataEntry(x: 3.0, y: 10.0),
        ChartDataEntry(x: 4.0, y: 1.0),
        ChartDataEntry(x: 5.0, y: 10.0),
        ChartDataEntry(x: 6.0, y: 1.0)
    ]
    
    var account: Account? {
        didSet {
            if let account = account {
                headerLabel.text = account.title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: K.colorBG2)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        customMarkerView.chartView = chartView
        chartView.marker = customMarkerView
        
        chartView.delegate = self
        
        addSubview(headerLabel)
        addSubview(chartView)
        
        headerLabel.fill(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 20, left: 10, bottom: 0, right: 0)
        )
        
        chartView.fill(
            top: headerLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 10, right: 0)
        )
        
        setData()
        
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValues, label: "Alimentacao")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 2
        set1.setColor(NSUIColor(hexString: "#FFBC25"))
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillColor = NSUIColor(hexString: "#FFBC25")
        
        let set2 = LineChartDataSet(entries: yValues2, label: "Transporte")
        set2.drawCirclesEnabled = false
        set2.mode = .cubicBezier
        set2.lineWidth = 2
        set2.setColor(NSUIColor(hexString: "#FF565E"))
        set2.drawFilledEnabled = true
        set2.drawHorizontalHighlightIndicatorEnabled = false
        set2.fillColor = NSUIColor(hexString: "#FF565E")
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setDrawValues(false)
        chartView.data = data
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
