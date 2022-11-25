import Foundation
import UIKit
import Lottie

class ViewController4: UIViewController {
    
    private lazy var buttonAccount: UIButton = {
        let buttom: UIButton = .roundedSymbolButton(
            symbolName: "arrow.forward",
            pointSize: 50,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorGreenOne)!,
            size: .init(width: 100, height: 100),
            cornerRadius: 50
        )
        buttom.tintColor = .white
        return buttom
    }()
    
    private lazy var labelFooter: UILabel = {
        let labelFooter: UILabel = .textLabel(text: "on_boarding_text_page_four".localized(), fontSize: 30, numberOfLines: 1, color: UIColor(named: K.colorText)!, type: .Light)
        labelFooter.textAlignment = .center
        return labelFooter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: K.colorBG1)!
        
        view.addSubview(buttonAccount)
        view.addSubview(labelFooter)
        
        buttonAccount.addTarget(self, action: #selector(goToAccountPage), for: .touchUpInside)
        
        buttonAccount.centralizeSuperview()
        
        labelFooter.fill(
            top: buttonAccount.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 20)
        )
        
    }
    
    @objc func goToAccountPage() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "closeOnBoarding")
        
        let baseController = BaseTabBarController()
        baseController.selectedIndex = 2
        baseController.modalPresentationStyle = .fullScreen
        present(baseController, animated: true, completion: nil)
    }
    
}
