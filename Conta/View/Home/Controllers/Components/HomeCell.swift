import Foundation
import UIKit
import Charts

class HomeCell: UICollectionViewCell, ChartViewDelegate {
    
    static var homeCell = "homeCell"
    
    var chartView: LineChartView = {
        var lineChartView = LineChartView()
        
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.animate(xAxisDuration: 1.0)
        lineChartView.xAxis.enabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        return lineChartView
    }()
    
    var yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 5.0),
        ChartDataEntry(x: 2.0, y: 7.0),
        ChartDataEntry(x: 3.0, y: 10.0),
        ChartDataEntry(x: 4.0, y: 5.0),
        ChartDataEntry(x: 5.0, y: 8.0)
    ]
    
    var yValues2: [ChartDataEntry] = [
        ChartDataEntry(x: 1.0, y: 10.5),
        ChartDataEntry(x: 2.0, y: 6.0),
        ChartDataEntry(x: 3.0, y: 7.5),
        ChartDataEntry(x: 4.0, y: 10.0),
        ChartDataEntry(x: 5.0, y: 5.0),
        ChartDataEntry(x: 6.0, y: 8.0)
    ]
    
    var account: Account? {
        didSet {
            if let account = account {}
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: K.colorBG2)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(chartView)
        chartView.fillSuperview()
        
        setData()
        
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValues, label: "Alimentacao")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 2
        set1.setColor(.yellow)
        //set1.drawFilledEnabled = true
        //set1.drawHorizontalHighlightIndicatorEnabled = false
        
        let set2 = LineChartDataSet(entries: yValues2, label: "Transporte")
        set2.drawCirclesEnabled = false
        set2.mode = .cubicBezier
        set2.lineWidth = 2
        set2.setColor(.red)
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setDrawValues(false)
        chartView.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
