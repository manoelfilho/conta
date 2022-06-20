import UIKit
extension UIButton {
    
    static func roundedCustomIconButton(imageName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, color: UIColor, size:CGSize, cornerRadius: CGFloat) -> UIButton {
        let roundedIconButton: UIButton = UIButton()
        let largeBoldDoc = UIImage(named: imageName)
        roundedIconButton.size(size: size)
        roundedIconButton.layer.cornerRadius = cornerRadius
        roundedIconButton.setImage(largeBoldDoc, for: .normal)
        roundedIconButton.backgroundColor = color
        roundedIconButton.tintColor = .white
        return roundedIconButton
    }
    
    static func buttonAccount(title: String, textColor:UIColor, color: UIColor = UIColor(named: K.colorBG2)!) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.image = UIImage(named: "accountCircle")
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20)
        configuration.baseForegroundColor = textColor
        configuration.baseBackgroundColor = color
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }
    
    static func roundedSymbolButton(symbolName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, color: UIColor, size:CGSize, cornerRadius: CGFloat) -> UIButton {
        let roundedIconButton: UIButton = UIButton()
        roundedIconButton.size(size: size)
        roundedIconButton.layer.cornerRadius = cornerRadius
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20), scale: .large)
        roundedIconButton.setImage(UIImage(systemName: symbolName, withConfiguration: config), for: .normal)
        roundedIconButton.backgroundColor = color
        roundedIconButton.tintColor = .white
        return roundedIconButton
    }
    
    
}
