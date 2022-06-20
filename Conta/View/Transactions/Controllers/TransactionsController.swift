import Foundation
import UIKit

class TransactionsController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UITextFieldDelegate {
    
    private var filter: [String:Any] = {
        let calendar = Calendar.current.dateComponents([.month, .year], from: Date())
        var filter: [String:Any] = [:]
            filter["type"] = nil
            filter["keyWord"] = nil
            filter["accounts"] = [Account]()
            filter["categories"] = [Category]()
            filter["month"] = calendar.month!
            filter["year"] = calendar.year!
        return filter
    }()
    
    private let transactionsPresenter: TransactionsPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionService: TransactionService = TransactionService(viewContext: context)
        let transactionsPresenter: TransactionsPresenter = TransactionsPresenter(transactionService: transactionService)
        return transactionsPresenter
   }()
    
    private var transactions: [Transaction] = []
        
    private var months:[(intMonth: Int, strMonth: String, intYear: Int)] = {
        var months:[(intMonth: Int, strMonth: String, intYear: Int)] = []
        let now = Date()
        let calendar = Calendar.current.dateComponents([.month, .year], from: now)
        let listMonths: [String] = Calendar.current.shortMonthSymbols
        months.append((intMonth: calendar.month!, strMonth: listMonths[calendar.month!-1].uppercased(), intYear: calendar.year!))
        for m in (1...1200){
            let dateBeforeMonth = Calendar.current.date(byAdding: .month, value: -m, to: now)
            let calendarBeforeMonth = Calendar.current.dateComponents([.month, .year], from: dateBeforeMonth!)
            months.append((intMonth: calendarBeforeMonth.month!, strMonth: listMonths[calendarBeforeMonth.month!-1].uppercased(), intYear: calendarBeforeMonth.year!))
        }
        return months.reversed()
    }()
    
    private let searchTextField: UITextField = {
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
    
    private let filterButton: UIButton = {
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
    
    private let stackSearchView: UIStackView = {
        let stackSearchView: UIStackView = UIStackView()
        stackSearchView.spacing = 10
        return stackSearchView
    }()
    
    private var borderScrollViewMonths: UIView = {
        let borderScrollViewMonths:UIView = UIView()
        borderScrollViewMonths.backgroundColor = UIColor(named: K.colorBG2)
        borderScrollViewMonths.size(size: .init(width: UIScreen.main.bounds.width, height: 5))
        return borderScrollViewMonths
    }()
    
    private var collectionViewMonths: UICollectionView = {
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
    
    private var tableTransactions: UITableView = {
        let tableTransactions: UITableView = UITableView()
        tableTransactions.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.cellTransaction)
        tableTransactions.backgroundColor = UIColor(named: K.colorBG1)
        tableTransactions.showsVerticalScrollIndicator = false
        tableTransactions.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        return tableTransactions
    }()
    
    private var buttonAdd: UIButton = {
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
        
        //MARK: Delegates
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
    }
    
    private func loadData(){
        transactionsPresenter.returnTransactions(with: filter)
    }
    
}

//MARK: Config View
extension TransactionsController {
    
    private func configView(){
                
        //MARK: View Configs
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        //MARK: Add Button
        buttonAdd.addTarget(self, action: #selector(self.goToNewTransactionController), for: .touchUpInside);
        
        //MARK: Add to view
        stackSearchView.addArrangedSubview(searchTextField)
        stackSearchView.addArrangedSubview(filterButton)
        
        //MARK: Collections View Month
        view.addSubview(stackSearchView)
        view.addSubview(borderScrollViewMonths)
        view.addSubview(collectionViewMonths)
        view.addSubview(tableTransactions)
        view.addSubview(buttonAdd)
        
        //MARK: Constraints
        
        stackSearchView.fill(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 70, left: 20, bottom: 0, right: 20))
        
        borderScrollViewMonths.fill(top: stackSearchView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))

        collectionViewMonths.fill(top: borderScrollViewMonths.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.bounds.width, height: 35))

        tableTransactions.fill(top: collectionViewMonths.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 0, right: 20))

        buttonAdd.fill(top: nil, leading: nil, bottom: view.bottomAnchor,trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 50, right: 20))
        
    }

}

//MARK: Presenter delegate
extension TransactionsController: TransactionsPresenterDelegate {
    
    func showError(message: String) {
        print(message)
    }
    
    func presentTransactions(transactions: [Transaction]) {
        self.transactions = transactions
        tableTransactions.reloadData()
    }
}

//MARK: Perfome
extension TransactionsController: FormTransactionControllerProtocol {

    @objc func goToNewTransactionController(){
        
        let newTransactionController = FormTransactionController()
        newTransactionController.transaction = Transaction(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        newTransactionController.setViewDelegate(transactionFormViewDelegate: self)
        newTransactionController.transaction?.type = Transaction.TYPE_TRANSACTION_DEBIT
        newTransactionController.transaction?.date = Date.now
        newTransactionController.modalTransitionStyle = .coverVertical
        present(newTransactionController, animated: true, completion: nil)
        
    }
    
    func didCloseModal() {
        transactionsPresenter.returnTransactions(with: filter)
    }

}

//MARK: TableView (tableTransactions) delegate methods
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
    
}

//MARK: CollectionView (collectionViewMonths) delegate methods
extension TransactionsController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filter["month"] = months[indexPath.row].intMonth
        filter["year"] = months[indexPath.row].intYear
        transactionsPresenter.returnTransactions(with: filter)
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

//MARK: Text Fields (searchTextField) delegate
extension TransactionsController{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count > 3 {
            filter["keyWord"] = text
            transactionsPresenter.returnTransactions(with: filter)
        }else if let text = textField.text, text == "" {
            filter["keyWord"] = nil
            transactionsPresenter.returnTransactions(with: filter)
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
