import Foundation
import CoreData

class Transaction: NSManagedObject {
    static let TYPE_TRANSACTION_DEBIT = "new_transaction_debit"
    static let TYPE_TRANSACTION_CREDIT = "new_transaction_credit"
}
