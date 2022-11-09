import Foundation
import CoreData

class CategoryService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func getCategories(filter: [String:Any] = [:], completion: @escaping (Result<[Category], ServiceError>) -> Void) {
        
        var predicates: [NSPredicate] = []
        
        //Category filter
        if let categoryId = filter["categoryId"] {
            let filterCategoryId = categoryId as! UUID
            let predicateCategory = NSPredicate(format: "category.id == %@", filterCategoryId as CVarArg)
            predicates.append(predicateCategory)
        }
        
        let sortTitle = NSSortDescriptor.init(key: "title", ascending: true)
        
        let request = Category.fetchRequest()
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [sortTitle]
        
        do {
            let categories = try viewContext.fetch(request)
            completion(.success(categories))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
    func saveCategory(completion: @escaping (Result<Bool, ServiceError>) -> Void){
        do {
            try viewContext.save()
            completion(.success(true))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
    func removeCategory(_ category: Category, completion: @escaping(Result<Bool, ServiceError>) -> Void){
        do {
            viewContext.delete(category)
            try viewContext.save()
            completion(.success(true))
        }catch{
            completion(.failure(.unexpectedError))
        }
    }
    
}
