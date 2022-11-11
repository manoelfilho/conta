import Foundation
import UIKit

class TransactionsListController: UITableViewController {
    
    var titlePage: String?
    var transactions: [Transaction]?
    
    var data: [Transaction] = []
    
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
        
        loadData()
        
    }
    
    func loadData() {
        if let values = transactions {
            print("passando aqui")
            DispatchQueue.main.async {
                self.transactions = values
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
}


extension TransactionsListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
