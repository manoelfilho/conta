import Foundation
import UIKit
import Charts

protocol ChartCellDelegate {
    func showDetails(account: String, transactions: [Transaction])
}

class ChartCell: UICollectionViewCell, ChartViewDelegate {
    
    private var delegate: ChartCellDelegate?
    
    func setViewDelegate(chartCellDelegate: ChartCellDelegate?){
        self.delegate = chartCellDelegate
    }
     
    static var chartCell = "chartCell"
    
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
                let data = buildData(transactions: transactions)
                lineChartView.data = data.0
                let formatterNumber = NumberFormatter()
                formatterNumber.locale = Locale.current
                formatterNumber.numberStyle = .currency
                if let labelUpValue = formatterNumber.string(from: data.1 as NSNumber) { labelUp.text = labelUpValue }
                if let labelDownValue = formatterNumber.string(from: data.2 as NSNumber) { labelDown.text = labelDownValue }
            }
        }
    }
    
    private lazy var headerStackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var listButton: UIButton = {
        
        let button: UIButton = .roundedSymbolButton(
            symbolName: "chart.bar.doc.horizontal",
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
    
    private lazy var lineChartView: LineChartView = {
        var lineChartView = LineChartView()
        lineChartView.animate(xAxisDuration: 0.5)
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.minOffset = 0
        lineChartView.extraBottomOffset = 10
        lineChartView.legend.xOffset = 20
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.legend.enabled = false
        return lineChartView
    }()
    
    private lazy var customMarkerView = CustomMarkerView()
    
    private lazy var footerView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    private lazy var upStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private lazy var downStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private lazy var upSymbol: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        imageView.tintColor = UIColor(named: K.colorGreenOne)
        return imageView
    }()
    
    private lazy var labelUp: UILabel = {
        let labelUp: UILabel = .textLabel(text: "0.0", fontSize: 15, color: UIColor(named: K.colorText)!)
        return labelUp
    }()
    
    private lazy var labelDown: UILabel = {
        let labelDown: UILabel = .textLabel(text: "0.0", fontSize: 15, color: UIColor(named: K.colorText)!)
        return labelDown
    }()
    
    private lazy var downSymbol: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.tintColor = UIColor(named: K.colorRedOne)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customMarkerView.chartView = lineChartView
        lineChartView.marker = customMarkerView
        lineChartView.delegate = self
        configView()
    }
    
    func configView() {
        
        backgroundColor = UIColor(named: K.colorBG2)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        listButton.addTarget(self, action: #selector(presentChartDetail), for: .touchUpInside)
        
        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(listButton)
        
        addSubview(headerStackView)
        addSubview(lineChartView)
        
        upStack.addArrangedSubview(upSymbol)
        upStack.addArrangedSubview(labelUp)
        
        footerView.addSubview(upStack)
        
        downStack.addArrangedSubview(labelDown)
        downStack.addArrangedSubview(downSymbol)
        
        footerView.addSubview(downStack)
        
        addSubview(footerView)
        
        headerStackView.fill(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 20)
        )
        
        lineChartView.fill(
            top: headerLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 10, right: 0)
        )
        
        footerView.fill(
            top: lineChartView.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
        
        upStack.fill(
            top: footerView.topAnchor,
            leading: footerView.leadingAnchor,
            bottom: footerView.bottomAnchor,
            trailing: nil,
            padding: .init(top: 0, left: 20, bottom: 10, right: 0)
        )
        
        downStack.fill(
            top: footerView.topAnchor,
            leading: nil,
            bottom: footerView.bottomAnchor,
            trailing: footerView.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 10, right: 20)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func presentChartDetail(){
        if let transactions = transactions, let account = title {
            self.delegate?.showDetails(account: account, transactions: transactions)
        }
    }
    
}

extension ChartCell {
    
    func buildData(transactions: [Transaction]) -> (LineChartData, Double, Double) {
        
        var dataSets: [LineChartDataSet] = []
        
        var doubleDays: [Double] = []
        var stringDays: [String] = []
        
        var sumCredit = 0.0
        var sumDebit = 0.0
        
        for transaction in transactions {
            let doubleDay = Double(transaction.date!.get(.day))
            if !doubleDays.contains(doubleDay) { doubleDays.append(doubleDay) }
            
            let formatterDate = DateFormatter()
            formatterDate.dateStyle = .medium
            let stringDay = formatterDate.string(from: transaction.date ?? Date.now)
            if !stringDays.contains(stringDay) { stringDays.append(stringDay) }
            
            if transaction.value < 0.0 { sumDebit += transaction.value }
            if transaction.value > 0.0 { sumCredit += transaction.value }
        }
        
        var yValues: [ChartDataEntry] = []
        
        for doubleDay in doubleDays {
            var sum = 0.0
            for transaction in transactions {
                
                if Double(transaction.date!.get(.day)) == doubleDay { sum += transaction.value }
            }
            yValues.append(ChartDataEntry(x: doubleDay, y: round(sum * 100) / 100.0))
        }
        
        let set = LineChartDataSet(entries: yValues, label: "transactions".localized().capitalized)
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 3
        set.setColor(UIColor(named: K.colorGreenOne)!)
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.fillColor = UIColor(named: K.colorGreenOne)!
        
        dataSets.append(set)
        
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        
        return (data, sumCredit, sumDebit)
    }
    
}
