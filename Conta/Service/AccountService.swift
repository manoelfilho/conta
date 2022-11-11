import Foundation
import CoreData

class AccountService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func getAccounts(filter: [String:Any] = [:], completion: @escaping (Result<[Account], ServiceError>) -> Void) {
        
        var predicates: [NSPredicate] = []
        
        //Account filter
        if let accountId = filter["accountId"] {
            let filterAccountId = accountId as! UUID
            let predicateAccount = NSPredicate(format: "account.id == %@", filterAccountId as CVarArg)
            predicates.append(predicateAccount)
        }
        
        let sortTitle = NSSortDescriptor.init(key: "title", ascending: true)
        
        let request = Account.fetchRequest()
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [sortTitle]
        
        do {
            let transactions = try viewContext.fetch(request)
            completion(.success(transactions))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
    func saveAccount(completion: @escaping (Result<Bool, ServiceError>) -> Void){
        do {
            try viewContext.save()
            completion(.success(true))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
    func removeAccount(_ account: Account, completion: @escaping(Result<Bool, ServiceError>) -> Void){
        do {
            viewContext.delete(account)
            try viewContext.save()
            completion(.success(true))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
    //return one dictionary of account with transactions of month [String:[Transaction]]
    func returnAccountsGrouped(completion: @escaping(Result<[String:[Transaction]], ServiceError>) -> Void) {
        
        var finalData: [String:[Transaction]] = [:]

        let sortTitle = NSSortDescriptor.init(key: "title", ascending: true)
        let request = Account.fetchRequest()
        request.sortDescriptors = [sortTitle]
        
        do {
        
            let accounts = try viewContext.fetch(request)
            
            for account in accounts {
                
                let predicateAccount = NSPredicate(format: "account.id == %@", account.id! as CVarArg)
                
                //last transaction
                let sortDate = NSSortDescriptor.init(key: "date", ascending: false)
                let requestTransaction = Transaction.fetchRequest()
                requestTransaction.sortDescriptors = [sortDate]
                requestTransaction.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateAccount])
                let lastTransaction = try viewContext.fetch(requestTransaction).first
                
                
                var predicates: [NSPredicate] = []
                //Month and Year filters
                let filterMonth = Calendar.current.dateComponents([.month], from: lastTransaction!.date!).month!
                let filterYear = Calendar.current.dateComponents([.year], from: lastTransaction!.date!).year!
                let componentsFirstDayOfMonth = DateComponents(year: filterYear, month: filterMonth, day: 1)
                let calendarFirstDay = Calendar.current
                let firstDay = calendarFirstDay.date(from: componentsFirstDayOfMonth)
                let lastDay = firstDay!.endOfMonth()
                predicates.append(predicateAccount)
                
                let predicatePeriod = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [firstDay!, lastDay])
                predicates.append(predicatePeriod)
                
                let sdSortDate = NSSortDescriptor.init(key: "date", ascending: true)
                
                let requestTransactions = Transaction.fetchRequest()
                requestTransactions.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                requestTransactions.sortDescriptors = [sdSortDate]
                
                let transactions = try viewContext.fetch(requestTransactions)
                
                finalData[account.title!] = transactions
                
            }
            
            completion(.success(finalData))
            
        }catch{
            completion(.failure(.unexpectedError))
        }
        
    }
    
}
