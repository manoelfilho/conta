import UIKit

class ChartDetailController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
    
    var titlePage: String? {
        didSet {
            if let titlePage = titlePage {
                headerLabel.text = titlePage
            }
        }
    }
    
    private lazy var notificationCenter = TransactionNotifications.shared
    
    private lazy var filter = TransactionsFilter.shared
    
    private lazy var transactionsPresenter: TransactionsPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionService: TransactionService = TransactionService(viewContext: context)
        let transactionsPresenter: TransactionsPresenter = TransactionsPresenter(transactionService: transactionService)
        return transactionsPresenter
    }()

    private lazy var headerStackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()

    private lazy var headerLabel: UILabel = {
        let headerLabel: UILabel = .textLabel(text: "home_title_page".localized(), fontSize: 20, color: .white, type: .Bold)
        return headerLabel
    }()

    private let closeButton: UIButton = .getCloseButton()
    
    var transactions: [Transaction] = []
    
    var accountId: UUID?
    
    var chartDetailView: ChartDetailView = ChartDetailView()
    
    private lazy var tableTransactions: UITableView = {
        let tableTransactions: UITableView = UITableView()
        tableTransactions.separatorInset = .init(top: 0, left: 70, bottom: 0, right: 0)
        tableTransactions.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.cellTransaction)
        tableTransactions.backgroundColor = UIColor(named: K.colorBG1)
        tableTransactions.showsVerticalScrollIndicator = false
        tableTransactions.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        return tableTransactions
    }()
    
    private lazy var months:[(intMonth: Int, strMonth: String, intYear: Int)] = []
    
    private lazy var borderScrollViewMonths: UIView = {
        let borderScrollViewMonths:UIView = UIView()
        borderScrollViewMonths.backgroundColor = UIColor(named: K.colorBG2)
        borderScrollViewMonths.size(size: .init(width: UIScreen.main.bounds.width, height: 5))
        return borderScrollViewMonths
    }()
    
    private lazy var collectionViewMonths: UICollectionView = {
        let layoutScrollMonth: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutScrollMonth.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutScrollMonth.itemSize = CGSize(width: 100, height: 35)
        layoutScrollMonth.scrollDirection = .horizontal
        
        let collectionViewMonths: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35), collectionViewLayout: layoutScrollMonth)
        collectionViewMonths.showsHorizontalScrollIndicator = false
        collectionViewMonths.register(ScrollMonthCell.self, forCellWithReuseIdentifier: ScrollMonthCell.cellScrollMonth)
        collectionViewMonths.backgroundColor = UIColor(named: K.colorBG3)
        return collectionViewMonths
    }()
    
    private lazy var emptyView: EmptyTableView = {
        let emptyView: EmptyTableView = EmptyTableView()
        return emptyView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configView()
        
        notificationCenter.addObserver(self, name: TransactionsFilter.nameNotification) { notificationName, filter in
            if let filter = filter as? [String: Any] {
                self.transactionsPresenter.returnTransactions(with: filter)
            }
        }
        
        transactionsPresenter.setViewDelegate(transactionsViewDelegate: self)
        
        collectionViewMonths.delegate = self
        collectionViewMonths.dataSource = self
        
        tableTransactions.delegate = self
        tableTransactions.dataSource = self
        
        if transactions.count > 0 {
            let accountId = transactions[0].account!.id
            self.accountId = accountId
            transactionsPresenter.returnFirstOfAccountTransactions(accountId: accountId!)
        } else {
            chartDetailView.isHidden = true
            tableTransactions.backgroundView = emptyView
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filter.clearOptions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filter.clearOptions()
    }
    
}

//MARK: CONFIG VIEW
extension ChartDetailController {
    
    private func configView(){
        
        //MARK: CONFIG VIEWS
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: K.colorBG2)
        
        chartDetailView.size(size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - 150))
        
        closeButton.addTarget(self, action: #selector(handleCloseClick), for: .touchUpInside)
        
        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(closeButton)
        
        //MARK: VIEWS AND CONSTRAINTS
        view.addSubview(headerStackView)
        view.addSubview(chartDetailView)
        view.addSubview(borderScrollViewMonths)
        view.addSubview(collectionViewMonths)
        view.addSubview(tableTransactions)
        
        headerStackView.fill(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 50, left: 20, bottom: 0, right: 20)
        )
        
        chartDetailView.fill(
            top: headerStackView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0)
        )
        
        borderScrollViewMonths.fill(
            top: chartDetailView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0)
        )
        
        collectionViewMonths.fill(
            top: borderScrollViewMonths.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
            size: .init(width: view.bounds.width, height: 35)
        )
        
        tableTransactions.fill(
            top: collectionViewMonths.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0)
        )
        
    }
    
    @objc func handleCloseClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: TRANSACTIONSPRESENTER DELEGATE
extension ChartDetailController: TransactionsPresenterDelegate {
    
    func presentTransactions(transactions: [Transaction]) {
        DispatchQueue.main.async {
            self.transactions = transactions
            self.chartDetailView.transactions = transactions
            self.tableTransactions.reloadData()
            
            if transactions.count == 0 {
                self.tableTransactions.backgroundView = self.emptyView
                self.chartDetailView.isHidden = true
            } else {
                self.tableTransactions.backgroundView = nil
                self.chartDetailView.isHidden = false
            }
        }
    }
    
    func presentFirstOfAllTransactions(transaction: Transaction) {
        let listMonths: [String] = Calendar.current.shortMonthSymbols
        var months:[(intMonth: Int, strMonth: String, intYear: Int)] = []
        
        let now = Date()
        let calendar = Calendar.current.dateComponents([.month, .year], from: now)
        
        months.append((intMonth: calendar.month!, strMonth: listMonths[calendar.month!-1].uppercased(), intYear: calendar.year!))
        
        let startDateComponents = Calendar.current.dateComponents([.year, .month], from: transaction.date!)
        let endDateComponents = Calendar.current.dateComponents([.year, .month], from: now)
        let diffInDate = Calendar.current.dateComponents([.month], from: startDateComponents, to: endDateComponents).month!
        
        if diffInDate > 0 {
            for m in (1...diffInDate){
                let dateBeforeMonth = Calendar.current.date(byAdding: .month, value: -m, to: now)
                let calendarBeforeMonth = Calendar.current.dateComponents([.month, .year], from: dateBeforeMonth!)
                months.append((intMonth: calendarBeforeMonth.month!, strMonth: listMonths[calendarBeforeMonth.month!-1].uppercased(), intYear: calendarBeforeMonth.year!))
            }
        }
        
        DispatchQueue.main.async {
            self.months = months.reversed()
            self.collectionViewMonths.reloadData()
            let indexPath = IndexPath(item: self.months.count-1, section: 0)
            self.collectionViewMonths.scrollToItem(at:indexPath, at: .right, animated: true)
        }
    }
    
    func presentErrorTransactions(message: String) {}
    
    func presentSuccessRemovingTransaction(message: String) {}
    
}

//MARK: TABLEVIEW DELEGATE
extension ChartDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.cellTransaction, for: indexPath) as! TransactionCell
        cell.selectionStyle = .none
        cell.transaction = self.transactions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
}

//MARK: COLLECTIONVIE DELEGATE
extension ChartDetailController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        filter.options["month"] = months[indexPath.row].intMonth
        filter.options["year"] = months[indexPath.row].intYear
        filter.options["accountId"] = self.accountId
        _ = try? notificationCenter.postNotification(TransactionsFilter.nameNotification, object: filter.options)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrollMonthCell.cellScrollMonth, for: indexPath) as! ScrollMonthCell
        cell.label = "\(months[indexPath.row].strMonth) \(months[indexPath.row].intYear)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 0)
    }
    
}
