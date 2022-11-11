import UIKit

class TransactionsController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
    
    private lazy var notificationCenter = TransactionNotifications.shared
    
    private lazy var filter = TransactionsFilter.shared
    
    private lazy var transactionsPresenter: TransactionsPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionService: TransactionService = TransactionService(viewContext: context)
        let transactionsPresenter: TransactionsPresenter = TransactionsPresenter(transactionService: transactionService)
        return transactionsPresenter
    }()
    
    private lazy var transactions: [Transaction] = []
    
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
    
    private lazy var searchTextField: UITextField = {
        let searchTextField: UITextField = CustomTextField()
        searchTextField.backgroundColor = UIColor(named: K.colorBG3)
        searchTextField.layer.cornerRadius = 10
        searchTextField.textColor = UIColor(named: K.colorText)
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "home_search".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText)!]
        )
        return searchTextField
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton: UIButton = .roundedCustomIconButton(
            imageName: "IconFilter",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorGreenOne)!,
            size: .init(width: 60, height: 60),
            cornerRadius: 10
        )
        return filterButton
    }()
    
    private lazy var stackSearchView: UIStackView = {
        let stackSearchView: UIStackView = UIStackView()
        stackSearchView.spacing = 10
        return stackSearchView
    }()
    
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
    
    private lazy var buttonAdd: UIButton = {
        let buttonAdd: UIButton = .roundedCustomIconButton(
            imageName: "IconPlus",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorGreenOne)!,
            size: .init(width: 60, height: 60),
            cornerRadius: 30
        )
        return buttonAdd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configView()
        
        notificationCenter.addObserver(self, name: TransactionsFilter.nameNotification) { notificationName, filter in
            if let filter = filter as? [String: Any] {
                if let keyWord = filter["keyWord"] as? String { self.searchTextField.text = keyWord } else { self.searchTextField.text = "" }
                self.transactionsPresenter.returnTransactions(with: filter)
            }
        }
        
        transactionsPresenter.setViewDelegate(transactionsViewDelegate: self)
        
        searchTextField.delegate = self
        
        collectionViewMonths.delegate = self
        collectionViewMonths.dataSource = self
        
        tableTransactions.delegate = self
        tableTransactions.dataSource = self
        
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexPath = IndexPath(item: months.count-1, section: 0)
        collectionViewMonths.scrollToItem(at:indexPath, at: .right, animated: true)
        loadData()
    }
    
    private func loadData(){
        transactionsPresenter.returnTransactions(with: filter.options)
        transactionsPresenter.returnFirstOfAllTransactions()
    }
    
}

//MARK: CONFIG VIEW
extension TransactionsController {
    
    private func configView(){
        
        //MARK: CONFIG VIEWS
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        //MARK: ACTIONS OF BUTTONS
        filterButton.addTarget(self, action: #selector(self.showFilterTransactionController), for: .touchUpInside)
        buttonAdd.addTarget(self, action: #selector(self.goToNewTransactionController), for: .touchUpInside);
        
        //MARK: VIEWS AND CONSTRAINTS
        stackSearchView.addArrangedSubview(searchTextField)
        stackSearchView.addArrangedSubview(filterButton)
        
        view.addSubview(stackSearchView)
        view.addSubview(borderScrollViewMonths)
        view.addSubview(collectionViewMonths)
        view.addSubview(tableTransactions)
        view.addSubview(buttonAdd)
        
        stackSearchView.fill(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 70, left: 20, bottom: 0, right: 20)
        )
        
        borderScrollViewMonths.fill(
            top: stackSearchView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 0)
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
        
        buttonAdd.fill(
            top: nil,
            leading: nil,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 120, right: 20)
        )
        
    }
    
}

//MARK: PRESENT FUNCTIONS
extension TransactionsController {
    
    @objc func goToNewTransactionController(){
        let newTransactionController = FormTransactionController()
        newTransactionController.transaction = Transaction(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        newTransactionController.setViewDelegate(transactionFormViewDelegate: self)
        newTransactionController.transaction?.type = Transaction.TYPE_TRANSACTION_DEBIT
        newTransactionController.transaction?.date = Date.now
        newTransactionController.modalTransitionStyle = .coverVertical
        present(newTransactionController, animated: true, completion: nil)
    }
    
    @objc func showFilterTransactionController(){
        let filterTransactionController = FilterTransactionController()
        filterTransactionController.modalTransitionStyle = .coverVertical
        present(filterTransactionController, animated: true, completion: nil)
    }
}

//MARK: TRANSACTIONSPRESENTER DELEGATE
extension TransactionsController: TransactionsPresenterDelegate {
    
    func presentSuccessRemovingTransaction(message: String) {}
    
    func presentErrorTransactions(message: String) {}
    
    func presentTransactions(transactions: [Transaction]) {
        DispatchQueue.main.async {
            self.transactions = transactions
            self.tableTransactions.reloadData()
        }
        transactionsPresenter.returnFirstOfAllTransactions()
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
        }
    }
    
}

//MARK: FORMTRANSACTIONSCONTROLLER DELEGATE
extension TransactionsController: FormTransactionControllerProtocol {
    
    func didCloseFormTransaction() {
        transactionsPresenter.returnTransactions(with: filter.options)
    }
    
}

//MARK: TABLEVIEW DELEGATE
extension TransactionsController: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formTransactionController = FormTransactionController()
        formTransactionController.setViewDelegate(transactionFormViewDelegate: self)
        formTransactionController.transaction = transactions[indexPath.row]
        formTransactionController.modalTransitionStyle = .coverVertical
        present(formTransactionController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = UIContextualAction(style: .destructive, title: "delete_transaction".localized()) { (action, vieew, completionHandler) in
            
            let dialogMessage = UIAlertController(title: "alert_warning".localized(), message: "confirm_removal_transaction".localized(), preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "confirm_removal_ok".localized(), style: .default, handler: { (action) -> Void in
                self.transactionsPresenter.removeTransaction(self.transactions[indexPath.row])
                self.transactions.remove(at: indexPath.row)
                self.loadData()
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
extension TransactionsController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
}

//MARK: TEXTFIELD DELEGATE
extension TransactionsController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count > 3 {
            filter.options["keyWord"] = text
            _ = try? notificationCenter.postNotification(TransactionsFilter.nameNotification, object: filter.options)
        }else if let text = textField.text, text == "" {
            filter.options["keyWord"] = nil
            _ = try? notificationCenter.postNotification(TransactionsFilter.nameNotification, object: filter.options)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
