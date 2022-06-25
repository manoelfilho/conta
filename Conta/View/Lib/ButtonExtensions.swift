import UIKit

class CustomButton: UIButton
{
    var uuid: UUID?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIButton {
    
    static func roundedCustomIconButton(imageName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, color: UIColor, size:CGSize, cornerRadius: CGFloat) -> CustomButton {
        let roundedIconButton: CustomButton = CustomButton()
        let largeBoldDoc = UIImage(named: imageName)
        roundedIconButton.size(size: size)
        roundedIconButton.layer.cornerRadius = cornerRadius
        roundedIconButton.setImage(largeBoldDoc, for: .normal)
        roundedIconButton.backgroundColor = color
        roundedIconButton.tintColor = .white
        return roundedIconButton
    }
    
    static func buttonAccount(title: String, textColor:UIColor, color: UIColor = UIColor(named: K.colorBG2)!) -> CustomButton {
        var configuration = CustomButton.Configuration.filled()
        configuration.title = title
        configuration.image = UIImage(named: "accountCircle")
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20)
        configuration.baseForegroundColor = textColor
        configuration.baseBackgroundColor = color
        let button = CustomButton(configuration: configuration, primaryAction: nil)
        return button
    }
    
    static func roundedSymbolButton(symbolName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, color: UIColor, size:CGSize, cornerRadius: CGFloat) -> CustomButton {
        let roundedIconButton: CustomButton = CustomButton()
        roundedIconButton.size(size: size)
        roundedIconButton.layer.cornerRadius = cornerRadius
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20), scale: .large)
        roundedIconButton.setImage(UIImage(systemName: symbolName, withConfiguration: config), for: .normal)
        roundedIconButton.backgroundColor = color
        roundedIconButton.tintColor = .white
        return roundedIconButton
    }
    
    
}
