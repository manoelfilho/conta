import Foundation

protocol CategoriesPresenterProtocol: NSObjectProtocol {
    func presentCategories(categories: [Category])
    func presentErrorCategories(message: String)
    func presentSuccessRemovingCategory(message: String)
}

class CategoriesPresenter {
    
    private let categoryService: CategoryService
    
    weak private var delegate: CategoriesPresenterProtocol?
    
    init(categoryService: CategoryService) {
        self.categoryService = categoryService
    }
    
    func setViewDelegate(viewDelegate: CategoriesPresenterProtocol?){
        self.delegate = viewDelegate
    }
    
    func returnCategories(filter: [String : Any]) {
        categoryService.getCategories(filter: filter) { [weak self] categories in
            guard self != nil else { return }
            switch categories {
            case .success(let categories):
                self?.delegate?.presentCategories(categories: categories)
            case .failure(let error):
                self?.delegate?.presentErrorCategories(message: error.localizedDescription)
            }
        }
    }
    
    func removeCategory(_ category: Category){
        categoryService.removeCategory(category) { [weak self] operation in
            guard let self = self else { return }
            switch operation {
            case .success(_):
                self.delegate?.presentSuccessRemovingCategory(message: "remove_category_success".localized())
            case .failure(.unexpectedError):
                self.delegate?.presentErrorCategories(message: "error_removing_data".localized())
            }
        }
    }
    
}

