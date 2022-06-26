import Foundation

protocol FormCategoryPresenterProtocol: NSObjectProtocol {
    func showError(message: String)
    func showSuccess(message: String)
}

class FormCategoryPresenter {
    
    private let categoryService: CategoryService
    
    weak private var delegate: FormCategoryPresenterProtocol?
    
    init(categoryService: CategoryService) {
        self.categoryService = categoryService
    }
    
    func setViewDelegate(formCategoryViewDelegate: FormCategoryPresenterProtocol?){
        self.delegate = formCategoryViewDelegate
    }
    
    func createCategory(){
        categoryService.saveCategory { result in
            switch result {
            case .success(_):
                self.delegate?.showSuccess(message: "new_transaction_success".localized())
            case .failure(_):
                self.delegate?.showError(message: "error_register_transaction".localized())
            }
        }
    }
    
}

