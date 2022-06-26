import Foundation
import UIKit

protocol FormCategoryControllerProtocol: NSObjectProtocol {
    func didCloseFormCategory()
}

class FormCategoryController: UIViewController{
    
    weak private var delegate: FormCategoryControllerProtocol?
    
    var category: Category? {
        didSet {
            titleTextField.text = category?.title
        }
    }
    
    private let formCategoryPresenter: FormCategoryPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let categoryService: CategoryService = CategoryService(viewContext: context)
        let formCategoryPresenter: FormCategoryPresenter = FormCategoryPresenter(categoryService: categoryService)
        return formCategoryPresenter
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
        let userImage = UIImageView(image: UIImage(named: "icon_tag"))
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
    
    private let titleTextField: UITextField = {
        let nameTextField: UITextField = CustomTextField()
        nameTextField.backgroundColor = UIColor(named: K.colorBG3)
        nameTextField.layer.cornerRadius = 10
        nameTextField.textColor = UIColor(named: K.colorText)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "category_register_title".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText)!]
        )
        nameTextField.tag = 0
        return nameTextField
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
        formCategoryPresenter.setViewDelegate(formCategoryViewDelegate: self)
        titleTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        category?.managedObjectContext?.rollback()
        delegate?.didCloseFormCategory()
    }
    
    func configView(){
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        cancellButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveCategory), for: .touchUpInside)
        
        view.addSubview(cancellButton)
        view.addSubview(headerView)
        
        colorAndTitleStack.addArrangedSubview(titleTextField)
        
        colorAndTitleStack.size(size: .init(width: view.bounds.width-40, height: 60))
        
        formView.addArrangedSubview(colorAndTitleStack)
        formView.addArrangedSubview(saveButton)
        view.addSubview(formView)
        
        cancellButton.fill(top: view.topAnchor,leading: nil,bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 20))
        headerView.fill(top: cancellButton.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        formView.fill(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    }
    
    func setViewDelegate(formCategoryControllerDelegate: FormCategoryControllerProtocol?){
        self.delegate = formCategoryControllerDelegate
    }
    
    @objc func cancel(){
        dismiss(animated: true)
    }
    
    @objc func saveCategory(){
        
        if category?.title == nil || category?.title == "" {

            let alert = UIAlertController(title: "alert_warning".localized(), message: "alert_fill_all_fields".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)

        } else {

            if category?.id == nil { category?.id = UUID() }
            formCategoryPresenter.createCategory()

        }
        
    }
    
}

extension FormCategoryController: FormCategoryPresenterProtocol {
    
    func showError(message: String) {}
    
    func showSuccess(message: String) {
        dismiss(animated: true)
    }
}

//MARK: Text Fields delegate
extension FormCategoryController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let strValue = textField.text!
        
        //TITLE
        if textField.tag == 0 {
            category?.title = strValue
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
