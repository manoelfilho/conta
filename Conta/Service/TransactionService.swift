import Foundation
import CoreData

class TransactionService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func getTransactions(filter: [String:Any], completion: @escaping (Result<[Transaction], ServiceError>) -> Void) {
        
        var predicates: [NSPredicate] = []

        //KeyWord
        if let keyword = filter["keyWord"] {
            let predicateKeyWord: NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", keyword as! CVarArg)
            predicates.append(predicateKeyWord)
        }
            
        //Type filter
        if let type = filter["type"] {
            let filterType = type as! String
            let predicateType = NSPredicate(format: "type == %@", filterType)
            predicates.append(predicateType)
        }

        //Account filter
        if let accountId = filter["accountId"] {
            let filterAccountId = accountId as! UUID
            let predicateAccount = NSPredicate(format: "account.id == %@", filterAccountId as CVarArg)
            predicates.append(predicateAccount)
        }

        //Category filter
        if let categorytId = filter["categoryId"] {
            let filterCategorytId = categorytId as! UUID
            let predicateCategory = NSPredicate(format: "category.id == %@", filterCategorytId as CVarArg)
            predicates.append(predicateCategory)
        }
        

        //Month and Year filters
        let filterMonth = filter["month"] as! Int
        let filterYear = filter["year"] as! Int
        let componentsFirstDayOfMonth = DateComponents(year: filterYear, month: filterMonth, day: 1)
        let calendarFirstDay = Calendar.current
        let firstDay = calendarFirstDay.date(from: componentsFirstDayOfMonth)
        let lastDay = firstDay!.endOfMonth()
        let predicatePeriod = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [firstDay!, lastDay])
        predicates.append(predicatePeriod)
                
        let request = Transaction.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let transactions = try viewContext.fetch(request)
            completion(.success(transactions))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
    func saveTransaction(completion: @escaping (Result<Bool, ServiceError>) -> Void){
        do {
            try viewContext.save()
            completion(.success(true))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
}
