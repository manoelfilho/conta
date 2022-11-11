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
    
    func returnAccountsGrouped(completion: @escaping(Result<[Account], ServiceError>) -> Void) {
        
        let sortTitle = NSSortDescriptor.init(key: "title", ascending: true)
        
        let request = Account.fetchRequest()
        
        request.sortDescriptors = [sortTitle]
        
        do {
            let transactions = try viewContext.fetch(request)
            completion(.success(transactions))
        }catch{
            completion(.failure(.unexpectedError))
        }
        
    }
    
}
