import Foundation

protocol TransactionsPresenterDelegate: NSObjectProtocol {
    func presentTransactions(transactions: [Transaction])
    func presentFirstOfAllTransactions(transaction: Transaction)
    func presentErrorTransactions(message: String)
    func presentSuccessRemovingTransaction(message: String)
}

class TransactionsPresenter {
    
    private let transactionService: TransactionService
    
    weak private var delegate: TransactionsPresenterDelegate?
    
    init(transactionService: TransactionService) {
        self.transactionService = transactionService
    }
    
    func setViewDelegate(transactionsViewDelegate: TransactionsPresenterDelegate?){
        self.delegate = transactionsViewDelegate
    }
    
    func returnTransactions(with filter: [String:Any]) {
        transactionService.getTransactions(filter: filter){ [weak self] transactions in
            guard let self = self else { return }
            switch transactions {
                case .success(let transactions):
                    self.delegate?.presentTransactions(transactions: transactions)
                case .failure(_):
                    self.delegate?.presentErrorTransactions(message: "error_return_data".localized())
            }
        }
    }
    
    func returnFirstOfAllTransactions(){
        transactionService.getFirstOfAllTransactions { [weak self] transaction in
            guard let self = self else { return }
            switch transaction {
            case .success(let transaction):
                self.delegate?.presentFirstOfAllTransactions(transaction: transaction)
            case .failure(_):
                self.delegate?.presentErrorTransactions(message: "error_return_data".localized())
            }
        }
    }
    
    func removeTransaction(_ transaction: Transaction){
        transactionService.removeTransaction(transaction) { [weak self] operation in
            guard let self = self else { return }
            switch operation {
            case .success(_):
                self.delegate?.presentSuccessRemovingTransaction(message: "remove_transaction_success".localized())
            case .failure(.unexpectedError):
                self.delegate?.presentErrorTransactions(message: "error_return_data".localized())
            }
        }
    }
    
}
