import Foundation
import CoreData

class CategoryService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func getCategories(filter: [String:Any], completion: @escaping (Result<[Category], ServiceError>) -> Void) {
        
        var predicates: [NSPredicate] = []
        
        //Category
        if let id = filter["categoryId"] {
            let predicateCategory = NSPredicate(format: "id == %@", id as! CVarArg)
            predicates.append(predicateCategory)
        }
        
        let request = Category.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let categories = try viewContext.fetch(request)
            completion(.success(categories))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
}

