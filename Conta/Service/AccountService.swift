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
                
                var date: Date = Date()
                if let lastTransaction = lastTransaction { date = lastTransaction.date! }
                
                //transactions
                
                var predicatesTransactions: [NSPredicate] = []
                var sortDescriptors: [NSSortDescriptor] = []
                
                //getting month and year
                let filterMonth = Calendar.current.dateComponents([.month], from: date).month!
                let filterYear = Calendar.current.dateComponents([.year], from: date).year!
                let componentsFirstDayOfMonth = DateComponents(year: filterYear, month: filterMonth, day: 1)
                let calendarFirstDay = Calendar.current
                let firstDay = calendarFirstDay.date(from: componentsFirstDayOfMonth)
                let lastDay = firstDay!.endOfMonth()
                
                let predicatePeriod = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [firstDay!, lastDay])
                let sdSortDate = NSSortDescriptor.init(key: "date", ascending: true)
                
                predicatesTransactions.append(predicateAccount)
                predicatesTransactions.append(predicatePeriod)
                sortDescriptors.append(sdSortDate)
                
                let requestTransactions = Transaction.fetchRequest()
                requestTransactions.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicatesTransactions)
                requestTransactions.sortDescriptors = sortDescriptors
                
                let transactions = try viewContext.fetch(requestTransactions)
                
                finalData[account.title!] = transactions
                
            }
            
            completion(.success(finalData))
            
        }catch{
            completion(.failure(.unexpectedError))
        }
        
    }
    
}
