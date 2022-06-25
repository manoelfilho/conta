import Foundation

protocol FormTransactionPresenterProtocol: NSObjectProtocol {
    func showError(message: String)
    func showSuccess(message: String)
    func presentAccounts(accounts: [Account])
    func presentCategories(categories: [Category])
}

class FormTransactionPresenter {
    
    private let accountService: AccountService
    private let categoryService: CategoryService
    private let transactionService: TransactionService
    
    weak private var delegate: FormTransactionPresenterProtocol?
    
    init(accountService: AccountService, categorySerive: CategoryService, transactionService: TransactionService) {
        self.accountService = accountService
        self.categoryService = categorySerive
        self.transactionService = transactionService
    }
    
    func setViewDelegate(accountsViewDelegate: FormTransactionPresenterProtocol?){
        self.delegate = accountsViewDelegate
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
    
    func createTransaction(){
        transactionService.saveTransaction { result in
            switch result {
            case .success(_):
                self.delegate?.showSuccess(message: "new_transaction_success".localized())
            case .failure(_):
                self.delegate?.showError(message: "error_register_transaction".localized())
            }
        }
    }
    
}
