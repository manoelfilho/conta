import Foundation

protocol CategoriesPresenterProtocol: NSObjectProtocol {
    func presentCategories(categories: [Category])
    func presentErrorCategories(message: String)
}

class CategoriesPresenter {
    
    private let categoryService: CategoryService
    
    weak private var delegate: CategoriesPresenterProtocol?
    
    init(categoryService: CategoryService) {
        self.categoryService = categoryService
    }
    
    func setViewDelegate(categoryServiceDelegate: CategoriesPresenterProtocol?){
        self.delegate = categoryServiceDelegate
    }
    
    func returnCategories(filter: [String : Any]) {
        categoryService.getCategories(filter: filter) { categories in
            switch categories {
            case .success(let categories):
                self.delegate?.presentCategories(categories: categories)
            case .failure(let error):
                self.delegate?.presentErrorCategories(message: error.localizedDescription)
            }
        }
    }
    
    
}

