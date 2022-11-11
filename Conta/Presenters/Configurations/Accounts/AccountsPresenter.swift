import Foundation

protocol AccountsPresenterProtocol: NSObjectProtocol {
    func presentAccounts(accounts: [Account])
    func presentErrorAccounts(message: String)
    func presentSuccessRemovingAccount(message: String)
}

class AccountsPresenter {
    
    private let accountService: AccountService
    
    weak private var delegate: AccountsPresenterProtocol?
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func setViewDelegate(viewDelegate: AccountsPresenterProtocol?){
        self.delegate = viewDelegate
    }
    
    func returnAccounts(filter: [String : Any]) {
        accountService.getAccounts(filter: filter) { accounts in
            switch accounts {
            case .success(let accounts):
                self.delegate?.presentAccounts(accounts: accounts)
            case .failure(let error):
                self.delegate?.presentErrorAccounts(message: error.localizedDescription)
            }
        }
    }
    
    func removeAccount(_ account: Account){
        accountService.removeAccount(account) { [weak self] operation in
            guard let self = self else { return }
            switch operation {
            case .success(_):
                self.delegate?.presentSuccessRemovingAccount(message: "remove_account_success".localized())
            case .failure(.unexpectedError):
                self.delegate?.presentErrorAccounts(message: "error_removing_data".localized())
            }
        }
    }
    
}
