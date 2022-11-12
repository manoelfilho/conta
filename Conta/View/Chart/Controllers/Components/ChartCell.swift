import Foundation
import UIKit
import Charts

class ChartCell: UICollectionViewCell, ChartViewDelegate {
    
    static var homeCell = "homeCell"
    
    var title: String? {
        didSet {
            if let title = title {
                headerLabel.text = title
            }
        }
    }
    
    var transactions: [Transaction]? {
        didSet {
            
            if let transactions = transactions {
    
                var dataSets: [LineChartDataSet] = []
                
                //LOOPS
                var categories: [String] = []
                var doubleDays: [Double] = []
                var stringDays: [String] = []
                
                for transaction in transactions {
                    if !categories.contains(transaction.category!.title!) { categories.append(transaction.category!.title!) }
                    let doubleDay = Double(transaction.date!.get(.day))
                    if !doubleDays.contains(doubleDay) { doubleDays.append(doubleDay) }
                    
                    let formatterDate = DateFormatter()
                    formatterDate.dateStyle = .medium
                    let stringDay = formatterDate.string(from: transaction.date ?? Date.now)
                    if !stringDays.contains(stringDay) { stringDays.append(stringDay) }
                }
                
                for category in categories {
            
                    var yValues: [ChartDataEntry] = []
                    
                    for doubleDay in doubleDays {
                        var sum = 0.0
                        for transaction in transactions {
                            if Double(transaction.date!.get(.day)) == doubleDay && transaction.category!.title == category { sum += transaction.value }
                        }
                        yValues.append(ChartDataEntry(x: doubleDay, y: round(sum * 100) / 100.0))
                    }
                    
                    let color = generateRandomHexadecimalColor()
                    
                    let set = LineChartDataSet(entries: yValues, label: category)
                    set.drawCirclesEnabled = false
                    set.mode = .cubicBezier
                    set.lineWidth = 3
                    set.setColor(NSUIColor(hexString: color))
                    set.drawFilledEnabled = true
                    set.drawHorizontalHighlightIndicatorEnabled = false
                    set.fillColor = NSUIColor(hexString: color)
                    
                    dataSets.append(set)
                }
                
                //FINAL LOOPS
                
                let data = LineChartData(dataSets: dataSets)
                data.setDrawValues(false)
                chartView.data = data
                
            }
        }
    }
    
    private lazy var headerLabel: UILabel = {
        let headerLabel: UILabel = .textLabel(text: "home_title_page".localized(), fontSize: 18, color: .white, type: .Bold)
        return headerLabel
    }()
    
    private lazy var chartView: LineChartView = {
        var lineChartView = LineChartView()
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.animate(xAxisDuration: 0.5)
        lineChartView.xAxis.enabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.minOffset = 0
        lineChartView.extraBottomOffset = 5
        lineChartView.legend.xOffset = 20
        return lineChartView
    }()
    
    let customMarkerView = CustomMarkerView()
    
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
            padding: .init(top: 20, left: 20, bottom: 0, right: 0)
        )
        
        chartView.fill(
            top: headerLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 10, right: 0)
        )
        
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
