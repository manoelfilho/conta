import UIKit

enum TypeFont {
    case Black
    case BlackItalic
    case Bold
    case BoldItalic
    case Heavy
    case HeavyItalic
    case Light
    case LightItalic
    case Medium
    case MediumItalic
    case Regular
    case RegularItalic
    case Semibold
    case SemiboldItalic
    case Thin
    case ThinItalic
    case Ultralight
    case UltralightItalic
}

extension UILabel {

    static func textLabel(text: String, fontSize: CGFloat, numberOfLines: Int = 1, color: UIColor, type: TypeFont = .Light ) -> UILabel {
        
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.text = text
        label.textColor = color
        
        switch type {
        case .Black:
            label.font = UIFont(name: "SFProDisplay-Black", size: fontSize)
        case .BlackItalic:
            label.font = UIFont(name: "SFProDisplay-BlackItalic", size: fontSize)
        case .Bold:
            label.font = UIFont(name: "SFProDisplay-Bold", size: fontSize)
        case .BoldItalic:
            label.font = UIFont(name: "SFProDisplay-BoldItalic", size: fontSize)
        case .Heavy:
            label.font = UIFont(name: "SFProDisplay-Heavy", size: fontSize)
        case .HeavyItalic:
            label.font = UIFont(name: "SFProDisplay-HeavyItalic", size: fontSize)
        case .Light:
            label.font = UIFont(name: "SFProDisplay-Light", size: fontSize)
        case .LightItalic:
            label.font = UIFont(name: "SFProDisplay-LightItalic", size: fontSize)
        case .Medium:
            label.font = UIFont(name: "SFProDisplay-Medium", size: fontSize)
        case .MediumItalic:
            label.font = UIFont(name: "SFProDisplay-MediumItalic", size: fontSize)
        case .Regular:
            label.font = UIFont(name: "SFProDisplay-Regular", size: fontSize)
        case .RegularItalic:
            label.font = UIFont(name: "SFProDisplay-RegularItalic", size: fontSize)
        case .Semibold:
            label.font = UIFont(name: "SFProDisplay-Semibold", size: fontSize)
        case .SemiboldItalic:
            label.font = UIFont(name: "SFProDisplay-SemiboldItalic", size: fontSize)
        case .Thin:
            label.font = UIFont(name: "SFProDisplay-Thin", size: fontSize)
        case .ThinItalic:
            label.font = UIFont(name: "SFProDisplay-ThinItalic", size: fontSize)
        case .Ultralight:
            label.font = UIFont(name: "SFProDisplay-Ultralight", size: fontSize)
        case .UltralightItalic:
            label.font = UIFont(name: "SFProDisplay-UltralightItalic", size: fontSize)
        }

        return label
    }
    
}

