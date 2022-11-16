import UIKit

class BaseTabBarController: CustomTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor(named: K.colorGreenTwo)
        tabBar.unselectedItemTintColor = UIColor.gray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: K.colorBG2)
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
        
        let chart = self.createTabBarItem(
            viewController: ChartsController(),
            imageName: "chart.bar.fill",
            imageSelectedName: "chart.bar.fill")
        
        let list = self.createTabBarItem(
            viewController: TransactionsController(),
            imageName: "house.fill",
            imageSelectedName: "house.fill")
        
        let configuration = self.createTabBarItem(
            viewController: ConfigurationsController(),
            imageName: "gear",
            imageSelectedName: "gear")
        
        viewControllers = [chart, list, configuration]
                
        selectedIndex = 1
        
    }
    
    private func createTabBarItem(viewController: UIViewController, imageName: String, imageSelectedName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.tintColor = .white
        
        viewController.tabBarItem.image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        viewController.tabBarItem.selectedImage = UIImage(systemName: imageSelectedName)
        
        self.hideKeyboardWhenTappedAround()
                
        return navController
        
    }
    
}

