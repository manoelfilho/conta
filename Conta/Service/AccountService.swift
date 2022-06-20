import Foundation
import CoreData

class AccountService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func getAccounts(filter: [String:Any], completion: @escaping (Result<[Account], ServiceError>) -> Void) {
        
        var predicates: [NSPredicate] = []
        
        //Account
        if let id = filter["accountId"] {
            let predicateAccount = NSPredicate(format: "id == %@", id as! CVarArg)
            predicates.append(predicateAccount)
        }
        
        let request = Account.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let transactions = try viewContext.fetch(request)
            completion(.success(transactions))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
}
