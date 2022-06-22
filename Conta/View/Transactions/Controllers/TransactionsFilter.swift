import Foundation

class TransactionsFilter {
    
    static let nameNotification = "ChangeTransactionFilter"
    
    static let shared = TransactionsFilter()
    
    var options: [String:Any]
    
    init() {
        var filter: [String:Any] = [:]
            filter["type"] = nil
            filter["keyWord"] = nil
            filter["accountId"] = nil
            filter["categoryId"] = nil
            filter["month"] = Calendar.current.dateComponents([.month], from: Date()).month!
            filter["year"] = Calendar.current.dateComponents([.year], from: Date()).year!
        self.options = filter
    }
    
    func clearOptions(){
        var filter: [String:Any] = [:]
            filter["type"] = nil
            filter["keyWord"] = nil
            filter["accountId"] = nil
            filter["categoryId"] = nil
            filter["month"] = Calendar.current.dateComponents([.month], from: Date()).month!
            filter["year"] = Calendar.current.dateComponents([.year], from: Date()).year!
        self.options = filter
    }
    
}
