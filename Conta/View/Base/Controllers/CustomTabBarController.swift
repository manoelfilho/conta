import UIKit

class CustomTabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, WeiTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class WeiTabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height += 10
            return sizeThatFits
        }
        
    }
    
}
