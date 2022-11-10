import Foundation
import UIKit

class AuthRegisterController: UIViewController{
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        headerView.backgroundColor = UIColor(named: K.colorBG1)
        let headerStackView = UIStackView()
        let nameLabel: UILabel = .textLabel(text: "register".localized(), fontSize: 30, color: .white, type: .Semibold)
        let userImage = UIImageView(image: UIImage(named: "icon_account"))
        headerStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(userImage)
        headerView.addSubview(headerStackView)
        headerStackView.distribution = .equalCentering
        headerStackView.alignment = .center
        headerStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        return headerView
    }()
    
    private lazy var footerView: UIView = {
        let footer: UIView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        return footer
    }()
    
    private lazy var formView: UIStackView = {
        let formView: UIStackView = UIStackView()
        formView.spacing = 10
        formView.axis = .vertical
        return formView
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField: UITextField = CustomTextField()
        nameTextField.backgroundColor = UIColor(named: K.colorBG3)
        nameTextField.layer.cornerRadius = 10
        nameTextField.textColor = UIColor(named: K.colorText)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "auth_register_name".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText)!]
        )
        return nameTextField
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField: UITextField = CustomTextField()
        emailTextField.backgroundColor = UIColor(named: K.colorBG3)
        emailTextField.layer.cornerRadius = 10
        emailTextField.textColor = UIColor(named: K.colorText)
        emailTextField.keyboardType = .emailAddress
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "auth_register_email".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText)!]
        )
        return emailTextField
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton: UIButton = UIButton()
        saveButton.backgroundColor = UIColor(named: K.colorGreenOne)
        saveButton.setTitle("auth_save_button".localized(), for: .normal)
        saveButton.layer.cornerRadius = 10
        return saveButton
    }()
    
    private lazy var labelFooter: UILabel = {
        let labelFooter: UILabel = .textLabel(text: "label_foot_configurations".localized(), fontSize: 15, numberOfLines: 4, color: UIColor(named: K.colorText)!, type: .Light)
        labelFooter.textAlignment = .center
        return labelFooter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        tabBarController?.tabBar.isHidden = true
        
        view.addSubview(headerView)
        formView.addArrangedSubview(nameTextField)
        formView.addArrangedSubview(emailTextField)
        formView.addArrangedSubview(saveButton)
        view.addSubview(formView)
        footerView.addSubview(labelFooter)
        view.addSubview(footerView)
        
        headerView.fill(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 120, left: 0, bottom: 0, right: 0))
                
        formView.fill(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true

        footerView.fill(top: formView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        labelFooter.fillSuperview(padding: .init(top: 25, left: 25, bottom: 25, right: 25))
        
    }
    
}
