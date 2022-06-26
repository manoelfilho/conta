import Foundation
import UIKit

protocol FormAccountControllerProtocol: NSObjectProtocol {
    func didCloseFormAccount()
}

class FormAccountController: UIViewController{
    
    weak private var delegate: FormAccountControllerProtocol?
    
    var account: Account? {
        didSet {
            titleTextField.text = account?.title
            collorButton.backgroundColor = UIColor(hexString: (account?.color)!)
            colorPicker.selectedColor = UIColor(hexString: (account?.color)!)
            valueTextField.text = Locale.current.regionCode! == "BR" ? account?.initialValue.description.replacingOccurrences(of: ".", with: ",") : account?.initialValue.description
        }
    }
    
    private let formAccountPresenter: FormAccountPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let accountService: AccountService = AccountService(viewContext: context)
        let formAccountPresenter: FormAccountPresenter = FormAccountPresenter(accountService: accountService)
        return formAccountPresenter
    }()
    
    private let cancellButton:UIButton = {
        let cancellButton: UIButton = UIButton()
        cancellButton.setTitle("new_transaction_cancell".localized(), for: .normal);
        cancellButton.tintColor = UIColor(named: K.colorText)
        return cancellButton
    }()
    
    private let headerView: UIView = {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        headerView.backgroundColor = UIColor(named: K.colorBG1)
        let headerStackView = UIStackView()
        let nameLabel: UILabel = .textLabel(text: "register".localized(), fontSize: 30, color: .white, type: .Semibold)
        let userImage = UIImageView(image: UIImage(named: "icon_wallet"))
        headerStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(userImage)
        headerView.addSubview(headerStackView)
        headerStackView.distribution = .equalCentering
        headerStackView.alignment = .center
        headerStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        return headerView
    }()
    
    private var formView: UIStackView = {
        let formView: UIStackView = UIStackView()
        formView.spacing = 10
        formView.axis = .vertical
        return formView
    }()
    
    private var colorAndTitleStack: UIStackView = {
        let colorAndTitleStack: UIStackView = UIStackView()
        colorAndTitleStack.spacing = 10
        colorAndTitleStack.axis = .horizontal
        return colorAndTitleStack
    }()
    
    private let collorButton: UIButton = {
        let collorButton: UIButton = .roundedCustomIconButton(
            imageName: "collor_picker",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorBG2)!,
            size: .init(width: 60, height: 60),
            cornerRadius: 10
        )
        return collorButton
    }()
    
    private let titleTextField: UITextField = {
        let nameTextField: UITextField = CustomTextField()
        nameTextField.backgroundColor = UIColor(named: K.colorBG3)
        nameTextField.layer.cornerRadius = 10
        nameTextField.textColor = UIColor(named: K.colorText)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "account_register_title".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText)!]
        )
        nameTextField.tag = 0
        return nameTextField
    }()
    
    private let colorPicker: UIColorPickerViewController = {
        let colorPicker: UIColorPickerViewController = UIColorPickerViewController()
        colorPicker.selectedColor = UIColor(named: K.colorBG2)!
        return colorPicker
    }()
    
    private let valueTextField: UITextField = {
        let valueTextField: UITextField = CustomTextField()
        valueTextField.backgroundColor = UIColor(named: K.colorBG3)
        valueTextField.layer.cornerRadius = 10
        valueTextField.textColor = UIColor(named: K.colorText)
        valueTextField.attributedPlaceholder = NSAttributedString(
            string: "account_register_initial_value".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText)!]
        )
        valueTextField.keyboardType = .decimalPad
        valueTextField.tag = 1
        return valueTextField
    }()
    
    private let saveButton: UIButton = {
        let saveButton: UIButton = UIButton()
        saveButton.backgroundColor = UIColor(named: K.colorGreenOne)
        saveButton.setTitle("auth_save_button".localized(), for: .normal)
        saveButton.layer.cornerRadius = 10
        return saveButton
    }()
    
    private let locale: String = Locale.current.regionCode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        
        formAccountPresenter.setViewDelegate(formAccountViewDelegate: self)
        titleTextField.delegate = self
        valueTextField.delegate = self
        colorPicker.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        account?.managedObjectContext?.rollback()
        delegate?.didCloseFormAccount()
    }
    
    func configView(){
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        cancellButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        collorButton.addTarget(self, action: #selector(chooseCollor), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveAccount), for: .touchUpInside)
        
        view.addSubview(cancellButton)
        view.addSubview(headerView)
        
        colorAndTitleStack.addArrangedSubview(collorButton)
        colorAndTitleStack.addArrangedSubview(titleTextField)
        
        colorAndTitleStack.size(size: .init(width: view.bounds.width-40, height: 60))
        
        formView.addArrangedSubview(colorAndTitleStack)
        formView.addArrangedSubview(valueTextField)
        formView.addArrangedSubview(saveButton)
        view.addSubview(formView)
        
        cancellButton.fill(top: view.topAnchor,leading: nil,bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 20))
        headerView.fill(top: cancellButton.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        formView.fill(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        valueTextField.translatesAutoresizingMaskIntoConstraints = false
        valueTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    }
    
    func setViewDelegate(formAccountControllerDelegate: FormAccountControllerProtocol?){
        self.delegate = formAccountControllerDelegate
    }
    
    @objc func cancel(){
        dismiss(animated: true)
    }
    
    @objc func chooseCollor(){
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func saveAccount(){
        
        if account?.title == nil || account?.title == "" || account?.color == nil || account?.initialValue == nil {

            let alert = UIAlertController(title: "alert_warning".localized(), message: "alert_fill_all_fields".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)

        } else {

            if account?.id == nil { account?.id = UUID() }
            formAccountPresenter.createAccount()

        }
        
    }
    
}

extension FormAccountController: FormAccountPresenterProtocol {
    
    func showError(message: String) {}
    
    func showSuccess(message: String) {
        dismiss(animated: true)
    }
}

extension FormAccountController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.collorButton.backgroundColor = viewController.selectedColor
        self.account?.color = viewController.selectedColor.hexStringFromColor()
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {}
    
}

//MARK: Text Fields delegate
extension FormAccountController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let strValue = textField.text!
        
        //TITLE
        if textField.tag == 0 {
            account?.title = strValue
        }
        
        //INITIAL VALUE
        if textField.tag == 1 {
            if locale == "BR" {
                if let value = Double(strValue.replacingOccurrences(of: ",", with: ".")) {
                    account?.initialValue = value
                } else {
                    account?.initialValue = 0.00
                }
            } else {
                if let value = Double(strValue) {
                    account?.initialValue = value
                } else {
                    account?.initialValue = 0.00
                }
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        valueTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
