import Foundation
import CoreData

class CategoryService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func getCategories(completion: @escaping (Result<[Category], ServiceError>) -> Void) {
        let request = Category.fetchRequest()
        do {
            let categories = try viewContext.fetch(request)
            completion(.success(categories))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
}

