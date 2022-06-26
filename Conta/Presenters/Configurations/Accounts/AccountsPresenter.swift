import Foundation

protocol AccountsPresenterProtocol: NSObjectProtocol {
    func presentAccounts(accounts: [Account])
    func presentErrorAccounts(message: String)
}

class AccountsPresenter {
    
    private let accountService: AccountService
    
    weak private var delegate: AccountsPresenterProtocol?
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func setViewDelegate(accountServiceDelegate: AccountsPresenterProtocol?){
        self.delegate = accountServiceDelegate
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
    
    
}
