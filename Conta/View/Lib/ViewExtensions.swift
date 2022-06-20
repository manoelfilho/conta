import UIKit

extension UIView {
    
    enum BorderSide {
        case top(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
        case bottom(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
        case right(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
        case left(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
    }
    
    
    func addBorder(on sides: [BorderSide]) {
        for side in sides {
            let border = UIView(frame: .zero)
            border.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(border)
            
            switch side {
            case .top(let thickness, let color):
                NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                border.backgroundColor = color
                
            case .bottom(let thickness, let color):
                NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                border.backgroundColor = color
                
            case .left(let thickness, let color):
                NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                border.backgroundColor = color
                
            case .right(let thickness, let color):
                NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                border.backgroundColor = color
            }
        }
    }
}
