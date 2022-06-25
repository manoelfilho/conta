import Foundation

protocol FilterTransactionPresenterProtocol: NSObjectProtocol {
    func showError(message: String)
    func showSuccess(message: String)
    func presentAccounts(accounts: [Account])
    func presentCategories(categories: [Category])
}

class FilterTransactionPresenter {
    
    private let accountService: AccountService
    private let categoryService: CategoryService
    
    weak private var delegate: FilterTransactionPresenterProtocol?
    
    init(accountService: AccountService, categorySerive: CategoryService) {
        self.accountService = accountService
        self.categoryService = categorySerive
    }
    
    func setViewDelegate(filterViewDelegate: FilterTransactionPresenterProtocol?){
        self.delegate = filterViewDelegate
    }
    
    func returnAccounts() {
        accountService.getAccounts(){ [weak self] accounts in
            guard let self = self else { return }
            switch accounts {
                case .success(let accounts):
                    self.delegate?.presentAccounts(accounts: accounts)
                case .failure(_):
                    self.delegate?.showError(message: "error_return_data".localized())
            }
        }
    }
    
    func returnCategories() {
        categoryService.getCategories(){ [weak self] categories in
            guard let self = self else { return }
            switch categories {
                case .success(let categories):
                    self.delegate?.presentCategories(categories: categories)
                case .failure(_):
                    self.delegate?.showError(message: "error_return_data".localized())
            }
        }
    }
    
}
