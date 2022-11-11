import Foundation


protocol HomePresenterProtocol: NSObjectProtocol {
    func presentAccounts(accounts: [Account])
    func presentErrorAccounts(message: String)
}

class HomePresenter {
    
    private let accountService: AccountService
    
    weak private var delegate: HomePresenterProtocol?
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func setViewDelegate(viewDelegate: HomePresenterProtocol?){
        self.delegate = viewDelegate
    }
    
    func returnAccountsGrouped() {
        accountService.returnAccountsGrouped() { accounts in
            switch accounts {
            case .success(let accounts):
                self.delegate?.presentAccounts(accounts: accounts)
            case .failure(let error):
                self.delegate?.presentErrorAccounts(message: error.localizedDescription)
            }
        }
    }
    
}
