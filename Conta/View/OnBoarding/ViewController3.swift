import Foundation
import UIKit
import Lottie

class ViewController3: UIViewController {
    
    private var animationView: AnimationView?
    
    private lazy var labelFooter: UILabel = {
        let labelFooter: UILabel = .textLabel(text: "on_boarding_text_page_three".localized(), fontSize: 20, numberOfLines: 4, color: UIColor(named: K.colorText)!, type: .Light)
        labelFooter.textAlignment = .center
        return labelFooter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: K.colorBG2)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationView = .init(name: "upload2")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        
        view.addSubview(animationView!)
        view.addSubview(labelFooter)
        
        labelFooter.fill(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 20, bottom: 150, right: 20)
        )
        
        animationView!.animationSpeed = 1.0
        animationView!.loopMode = .loop
        animationView!.backgroundBehavior = .pauseAndRestore
        animationView!.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animationView?.stop()
        animationView?.removeFromSuperview()
    }

}
