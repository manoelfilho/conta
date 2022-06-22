import Foundation
import CoreData

class AccountService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func getAccounts(completion: @escaping (Result<[Account], ServiceError>) -> Void) {
        let request = Account.fetchRequest()
        do {
            let transactions = try viewContext.fetch(request)
            completion(.success(transactions))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
}
