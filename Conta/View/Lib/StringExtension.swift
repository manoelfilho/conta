import Foundation
extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func currencyFormat() -> String {
    
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
    
        var amountWithPrefix = self
    
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
    
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        guard number != 0 as NSNumber else {
            return ""
        }
    
        return formatter.string(from: number)!
        
    }
    
    func currencyToDouble() -> NSNumber {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let amountWithPrefix = regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        let double = (amountWithPrefix as NSString).doubleValue
        var number: NSNumber!
            number = NSNumber(value: (double / 100))
        return number
    }
    
    //Get the filname from a String
    func fileName() -> String{
        return URL(filePath: self).deletingPathExtension().lastPathComponent
    }
    
    //Get the extension from a String
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
