import UIKit

class ChartDetailController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
    
    private lazy var notificationCenter = TransactionNotifications.shared
    
    private lazy var filter = TransactionsFilter.shared
    
    private lazy var transactionsPresenter: TransactionsPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionService: TransactionService = TransactionService(viewContext: context)
        let transactionsPresenter: TransactionsPresenter = TransactionsPresenter(transactionService: transactionService)
        return transactionsPresenter
    }()
    
    var transactions: [Transaction] = []
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//MARK: CONFIG VIEW
extension ChartDetailController {
    
    private func configView(){
        
        //MARK: CONFIG VIEWS
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        chartDetailView.size(size: .init(width: UIScreen.main.bounds.width, height: 300))
        
        //MARK: VIEWS AND CONSTRAINTS
        view.addSubview(chartDetailView)
        view.addSubview(borderScrollViewMonths)
        view.addSubview(collectionViewMonths)
        view.addSubview(tableTransactions)
        
        chartDetailView.fill(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 0)
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
    
}

//MARK: TRANSACTIONSPRESENTER DELEGATE
extension ChartDetailController: TransactionsPresenterDelegate {
    
    func presentTransactions(transactions: [Transaction]) {}
    
    func presentFirstOfAllTransactions(transaction: Transaction) {}
    
    func presentErrorTransactions(message: String) {}
    
    func presentSuccessRemovingTransaction(message: String) {}
    
}

//MARK: FORMTRANSACTIONSCONTROLLER DELEGATE
extension ChartDetailController: FormTransactionControllerProtocol {
    
    func didCloseFormTransaction() {}
    
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive, title: "delete_transaction".localized()) { (action, vieew, completionHandler) in
            let dialogMessage = UIAlertController(title: "alert_warning".localized(), message: "confirm_removal_transaction".localized(), preferredStyle: .alert)
            let ok = UIAlertAction(title: "confirm_removal_ok".localized(), style: .default, handler: { (action) -> Void in
                self.transactionsPresenter.removeTransaction(self.transactions[indexPath.row])
                self.transactions.remove(at: indexPath.row)
            })
            let cancel = UIAlertAction(title: "confirm_removal_not".localized(), style: .cancel) { (action) -> Void in }
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
        trash.image = UIImage(named: "trash")
        trash.backgroundColor = UIColor(named: K.colorRedOne)
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

//MARK: COLLECTIONVIE DELEGATE
extension ChartDetailController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filter.options["month"] = months[indexPath.row].intMonth
        filter.options["year"] = months[indexPath.row].intYear
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
