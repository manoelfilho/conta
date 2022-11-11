import Foundation
import UIKit

class TransactionsListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titlePage: String?
    var transactions: [Transaction]?
    
    var data: [Transaction] = []
    
    private lazy var tableView: UITableView = {
        let tableTransactions: UITableView = UITableView()
        tableTransactions.separatorInset = .init(top: 0, left: 70, bottom: 0, right: 0)
        tableTransactions.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.cellTransaction)
        tableTransactions.backgroundColor = UIColor(named: K.colorBG1)
        tableTransactions.showsVerticalScrollIndicator = false
        tableTransactions.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        return tableTransactions
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.colorBG2)
        
        tableView.separatorInset = .init(top: 0, left: 70, bottom: 0, right: 0)
        
        tableView.backgroundColor = UIColor(named: K.colorBG1)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        
        loadData()
        
    }
    
    func loadData() {
        if let values = transactions {
            DispatchQueue.main.async {
                self.transactions = values
                self.tableView.reloadData()
            }
        }
    }
    
}


extension TransactionsListController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.cellTransaction, for: indexPath) as! TransactionCell
        cell.selectionStyle = .none
        cell.transaction = self.data[indexPath.row]
        return cell
    }
    
    
}
