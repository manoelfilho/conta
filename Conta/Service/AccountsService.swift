import Foundation

class AccountsService {
    
    func getAccounts(completion: @escaping ([Account]) -> Void) {
        let accounts: [Account] = []
        completion(accounts)
    }
}
