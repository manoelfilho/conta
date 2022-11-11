import UIKit

class TransactionDetailViewController: UIViewController {
    
    var titlePage: String?
    var transactions: [Transaction]?
    
    let closeButton: UIButton = .getCloseButton()
    
    var centerView: UIView?
    var frame: CGRect?
    
    var topConstraints: NSLayoutConstraint?
    var leadingConstraints: NSLayoutConstraint?
    var widthConstraints: NSLayoutConstraint?
    var heigthConstraints: NSLayoutConstraint?
    
    var handleClose: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transactionsController = TransactionsListController()
        
        transactionsController.titlePage = self.titlePage
        transactionsController.transactions = self.transactions
        
        self.centerView = transactionsController.view
        self.animation()
        
        view.backgroundColor = .clear
    }
    
    
    func addButtonClose(){
        view.addSubview(closeButton)
        closeButton.alpha = 0
        closeButton.addTarget(self, action: #selector(handleCloseClick), for: .touchUpInside)
        closeButton.fill(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 18, left: 0, bottom: 0, right: 24),
            size: .init(width: 32, height: 32)
        )
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .showHideTransitionViews, animations: {
            self.closeButton.alpha = 1
        }, completion: nil)
    }
    
    func animationClose(){
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .overrideInheritedCurve,
            animations: {
                if let frame = self.frame {
                    self.topConstraints?.constant = frame.origin.y
                    self.leadingConstraints?.constant = frame.origin.x
                    self.widthConstraints?.constant = frame.width
                    self.heigthConstraints?.constant = frame.height
                    self.centerView?.layer.cornerRadius = 16
                    self.view.layoutIfNeeded()
                }
            }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func handleCloseClick() {
        self.closeButton.isHidden = true
        self.handleClose?()
        self.animationClose()
    }
    
    func animation(){
        
        guard let centerView = self.centerView else { return }
        guard let frame = self.frame else { return }
        
        centerView.layer.cornerRadius = 16
        centerView.clipsToBounds = true
        
        view.addSubview(centerView)
        self.addButtonClose()
        
        centerView.translatesAutoresizingMaskIntoConstraints = false
        self.topConstraints = centerView.topAnchor.constraint(equalTo: view.topAnchor, constant: frame.origin.y)
        self.leadingConstraints = centerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: frame.origin.x)
        self.widthConstraints = centerView.widthAnchor.constraint(equalToConstant: frame.width)
        self.heigthConstraints = centerView.heightAnchor.constraint(equalToConstant: frame.height)
        
        self.topConstraints?.isActive = true
        self.leadingConstraints?.isActive = true
        self.widthConstraints?.isActive = true
        self.heigthConstraints?.isActive = true
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .overrideInheritedCurve, animations: {
            
            self.topConstraints?.constant = 0
            self.leadingConstraints?.constant = 0
            self.widthConstraints?.constant = self.view.frame.width
            self.heigthConstraints?.constant = self.view.frame.height
            
            self.centerView?.layer.cornerRadius = 0
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
}

