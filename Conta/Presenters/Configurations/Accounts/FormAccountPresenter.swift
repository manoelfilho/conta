import Foundation

protocol FormAccountPresenterProtocol: NSObjectProtocol {
    func showError(message: String)
    func showSuccess(message: String)
}

class FormAccountPresenter {
    
    private let accountService: AccountService
    
    weak private var delegate: FormAccountPresenterProtocol?
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func setViewDelegate(formAccountViewDelegate: FormAccountPresenterProtocol?){
        self.delegate = formAccountViewDelegate
    }
    
    func createAccount(){
        accountService.saveAccount { result in
            switch result {
            case .success(_):
                self.delegate?.showSuccess(message: "new_transaction_success".localized())
            case .failure(_):
                self.delegate?.showError(message: "error_register_transaction".localized())
            }
        }
    }
    
}
