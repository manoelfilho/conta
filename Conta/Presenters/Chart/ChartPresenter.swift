import Foundation


protocol ChartPresenterProtocol: NSObjectProtocol {
    func presentAccounts(accounts: [String:[Transaction]])
    func presentErrorAccounts(message: String)
}

class ChartPresenter {
    
    private let accountService: AccountService
    
    weak private var delegate: ChartPresenterProtocol?
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func setViewDelegate(viewDelegate: ChartPresenterProtocol?){
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
