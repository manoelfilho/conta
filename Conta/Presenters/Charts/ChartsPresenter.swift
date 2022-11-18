import Foundation


protocol ChartsPresenterProtocol: NSObjectProtocol {
    func presentAccounts(accounts: [String:[Transaction]])
    func presentErrorAccounts(message: String)
}

class ChartsPresenter {
    
    private let accountService: AccountService
    
    weak private var delegate: ChartsPresenterProtocol?
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func setViewDelegate(viewDelegate: ChartsPresenterProtocol?){
        self.delegate = viewDelegate
    }
    
    func returnAccountsGrouped() {
        accountService.returnAccountsGrouped() { [weak self] accounts in
            guard self != nil else { return }
            switch accounts {
            case .success(let accounts):
                self?.delegate?.presentAccounts(accounts: accounts)
            case .failure(let error):
                self?.delegate?.presentErrorAccounts(message: error.localizedDescription)
            }
        }
    }
    
}
