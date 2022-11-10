import Foundation
import UIKit

protocol FormTransactionControllerProtocol: NSObjectProtocol {
    func didCloseFormTransaction()
}

class FormTransactionController: UIViewController {
    
    weak private var delegate: FormTransactionControllerProtocol?
    
    var transaction: Transaction? {
        didSet {
            if let transaction = transaction {
                if transaction.id != nil { saveButton.setTitle("new_transaction_edit_transaction".localized(), for: .normal) }
                
                let formatterNumber = NumberFormatter()
                formatterNumber.locale = Locale.current
                formatterNumber.numberStyle = .currency
                if let formattedTipAmount = formatterNumber.string(from: transaction.value as NSNumber) {
                    inputValue.text = formattedTipAmount
                }
                
                switch transaction.type {
                    case Transaction.TYPE_TRANSACTION_DEBIT:
                        segmentedTypeControll.selectedSegmentIndex = 0
                    case Transaction.TYPE_TRANSACTION_CREDIT:
                        segmentedTypeControll.selectedSegmentIndex = 1
                    default:
                        segmentedTypeControll.selectedSegmentIndex = 0
                }
                
                datePicker.date = transaction.date ?? Date.now
                inputDescription.text = transaction.title
            }
        }
    }
        
    private lazy var formTransactionPresenter: FormTransactionPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let accountService = AccountService(viewContext: context)
        let categoryService = CategoryService(viewContext: context)
        let transactionService = TransactionService(viewContext: context)
        let formTransactionPresenter = FormTransactionPresenter(accountService: accountService, categorySerive: categoryService, transactionService: transactionService)
        return formTransactionPresenter
   }()
    
    private var accounts: [Account]?
    
    private var categories: [Category]?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var cancellButton:UIButton = {
        let cancellButton: UIButton = UIButton()
        cancellButton.setTitle("new_transaction_cancell".localized(), for: .normal);
        cancellButton.tintColor = UIColor(named: K.colorText)
        return cancellButton
    }()
    
    private lazy var inputValue: UITextField = {
        let inputValue: CustomTextField = CustomTextField()
        inputValue.padding = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        inputValue.tag = 1
        inputValue.textColor = .white
        inputValue.attributedPlaceholder = NSAttributedString(
            string: "new_transaction_value".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText) ?? UIColor.white]
        )
        inputValue.font = UIFont(name: "SFProDisplay-Regular", size: 35)
        inputValue.becomeFirstResponder()
        return inputValue
    }()
    
    private lazy var segmentedTypeControll: UISegmentedControl = {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let segmentedTypeControll = UISegmentedControl(items: [Transaction.TYPE_TRANSACTION_DEBIT.localized(), Transaction.TYPE_TRANSACTION_CREDIT.localized()])
        segmentedTypeControll.selectedSegmentIndex = 0
        segmentedTypeControll.selectedSegmentTintColor = UIColor(named: K.colorGreenOne)
        segmentedTypeControll.backgroundColor = UIColor(named: K.colorBG2)
        segmentedTypeControll.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedTypeControll.setTitleTextAttributes(titleTextAttributes, for: .selected)
        return segmentedTypeControll
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.date = .now
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .leading
        datePicker.maximumDate = .now
        return datePicker
    }()
    
    private lazy var accountLabel: UILabel = {
        let accountsLabel: UILabel = .textLabel(
            text: "new_transaction_account".localized(),
            fontSize: 15,
            numberOfLines: 1,
            color: .white,
            type: .Semibold
        )
        return accountsLabel
    }()
    
    private lazy var categoryLabel: UILabel = {
        let categoryLabel: UILabel = .textLabel(
            text: "new_transaction_category".localized(),
            fontSize: 15,
            numberOfLines: 1,
            color: .white,
            type: .Semibold
        )
        return categoryLabel
    }()
    
    private lazy var inputDescription: UITextField = {
        let inputDescription: CustomTextField = CustomTextField()
        inputDescription.tag = 2
        //inputDescription.padding = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        inputDescription.textColor = .white
        inputDescription.attributedPlaceholder = NSAttributedString(
            string: "new_transaction_description".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText) ?? UIColor.white]
        )
        inputDescription.font = UIFont(name: "SFProDisplay-Regular", size: 20)
        inputDescription.backgroundColor = UIColor(named: K.colorBG2)
        inputDescription.layer.cornerRadius = 10
        return inputDescription
    }()
    
    private lazy var stackViewInputValue: UIStackView = {
        let stackViewInputValue: UIStackView = UIStackView()
        stackViewInputValue.distribution = .fillProportionally
        stackViewInputValue.alignment = .center
        stackViewInputValue.addBorder(on: [.bottom(thickness: 1.0, color: UIColor(named: K.colorText)!)])
        return stackViewInputValue
        
    }()
    
    private lazy var wrapperAccountButtons: UIScrollView = {
        let wrapperAccountButtons: UIScrollView = UIScrollView()
        wrapperAccountButtons.showsHorizontalScrollIndicator = false
        wrapperAccountButtons.isDirectionalLockEnabled = true
        return wrapperAccountButtons
    }()
    
    private lazy var stackAccountButtons: UIStackView = {
        let stackAccountButtons: UIStackView = UIStackView()
        stackAccountButtons.spacing = 10
        return stackAccountButtons
    }()
    
    private lazy var wrapperCategoryButtons: UIScrollView = {
        let wrapperCategoryButtons: UIScrollView = UIScrollView()
        wrapperCategoryButtons.showsHorizontalScrollIndicator = false
        wrapperCategoryButtons.isDirectionalLockEnabled = true
        return wrapperCategoryButtons
    }()
    
    private lazy var stackCategoryButtons: UIStackView = {
        let stackCategoryButtons: UIStackView = UIStackView()
        stackCategoryButtons.spacing = 10
        return stackCategoryButtons
    }()
    
    private lazy var stackViewDescription: UIStackView = {
        let stackViewDescription: UIStackView = UIStackView()
        stackViewDescription.distribution = .fillProportionally
        stackViewDescription.alignment = .center
        /*
         stackViewDescription.addBorder(on: [
            .bottom(thickness: 1.0, color: UIColor(named: K.colorText)!),
            .left(thickness: 1.0, color: UIColor(named: K.colorText)!),
            .top(thickness: 1.0, color: UIColor(named: K.colorText)!),
            .right(thickness: 1.0, color: UIColor(named: K.colorText)!)
        ])
         */
        return stackViewDescription
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton: UIButton = UIButton()
        saveButton.backgroundColor = UIColor(named: K.colorGreenOne)
        saveButton.setTitle("new_transaction_save_transaction".localized(), for: .normal)
        saveButton.layer.cornerRadius = 10
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        inputValue.delegate = self
        inputDescription.delegate = self
        formTransactionPresenter.setViewDelegate(accountsViewDelegate: self)

        configView()
        
        formTransactionPresenter.returnAccounts()
        formTransactionPresenter.returnCategories()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        transaction?.managedObjectContext?.rollback()
        delegate?.didCloseFormTransaction()
    }
    
}

//MARK: FUNCTIONS
extension FormTransactionController {
    
    func setViewDelegate(transactionFormViewDelegate: FormTransactionControllerProtocol?){
        self.delegate = transactionFormViewDelegate
    }
    
    private func configView(){
        
        //MARK: KEYBOARD NOTIFICATION
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        //MARK: CONFIG VIEW
        view.backgroundColor = UIColor(named: K.colorBG1)
        self.hideKeyboardWhenTappedAround()
        
        //MARK: TARGET FUNCTIONS
        cancellButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        segmentedTypeControll.addTarget(self, action: #selector(changeType), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveTransaction), for: .touchUpInside)
        
        //MARK: VIEWS AND CONSTRAINTS
        stackViewInputValue.addArrangedSubview(inputValue)
        
        stackViewDescription.addArrangedSubview(inputDescription)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(cancellButton)
        contentView.addSubview(stackViewInputValue)
        contentView.addSubview(segmentedTypeControll)
        contentView.addSubview(datePicker)
        contentView.addSubview(accountLabel)
        
        wrapperAccountButtons.addSubview(stackAccountButtons)
        
        contentView.addSubview(wrapperAccountButtons)
        contentView.addSubview(categoryLabel)
        
        wrapperCategoryButtons.addSubview(stackCategoryButtons)
        
        contentView.addSubview(wrapperCategoryButtons)
        contentView.addSubview(stackViewDescription)
        contentView.addSubview(saveButton)
        
        //MARK: CONSTRAINTS
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        cancellButton.fill(
                top: contentView.topAnchor,
                leading: nil,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 20)
        )

        stackViewInputValue.fill(
                top: cancellButton.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: contentView.bounds.width, height: 50)
        )

        segmentedTypeControll.fill(
                top: stackViewInputValue.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: contentView.bounds.width, height: 30)
        )

        datePicker.fill(
                top: segmentedTypeControll.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: contentView.bounds.width, height: 50)
        )

        accountLabel.fill(
                top: datePicker.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 20, bottom: 0, right: 20)
        )

        wrapperAccountButtons.fill(
                top: accountLabel.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: contentView.bounds.width, height: 60)
        )

        stackAccountButtons.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))

        categoryLabel.fill(
                top: stackAccountButtons.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(
                top: 20, left: 20, bottom: 0, right: 20)
        )

        wrapperCategoryButtons.fill(
                top: categoryLabel.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: contentView.bounds.width, height: 120)
        )

        stackCategoryButtons.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))

        stackViewDescription.fill(
                top: stackCategoryButtons.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: contentView.bounds.width, height: 40)
        )

        saveButton.fill(
                top: stackViewDescription.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: contentView.bottomAnchor,
                trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 20, bottom: 350, right: 20), size: .init(width: contentView.bounds.width, height: 40)
        )
        
    }
    
    @objc func keyboardDidShown (_ aNotification: Notification) {
        if inputDescription.isEditing {
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
        if inputValue.isEditing {
            let topOffset = CGPoint(x: 0, y: 0)
            scrollView.setContentOffset(topOffset, animated: true)
        }
    }

    @objc func keyboardWillBeHidden (_ aNotification: Notification) {
        let topOffset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(topOffset, animated: true)
    }
    
    @objc private func dismissController() {
        dismiss(animated: true)
    }
    
    @objc private func changeType(sender: UISegmentedControl) {
        transaction?.type = sender.selectedSegmentIndex == 0 ? Transaction.TYPE_TRANSACTION_DEBIT : Transaction.TYPE_TRANSACTION_CREDIT
    }
    
    @objc private func changeDate(sender: UIDatePicker){
        transaction?.date = sender.date
    }
    
    @objc private func chooseAccount(sender:UIButton){
        for view in stackAccountButtons.arrangedSubviews {
            if let button = view as? UIButton, button.tag != sender.tag {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorBG2)
            }else if let button = view as? UIButton {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorGreenOne)
            }
        }
        transaction?.account = accounts![sender.tag-1]
    }
    
    @objc private func createNewAccount(sender:UIButton){
        for view in stackAccountButtons.arrangedSubviews {
            if let button = view as? UIButton {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorBG2)
            }
        }
        transaction?.account = nil
    }
    
    @objc private func chooseCategory(sender:UIButton){
        for view in stackCategoryButtons.arrangedSubviews {
            if let button = view as? UIStackView, button.arrangedSubviews[0].tag != sender.tag {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorBG2)
            }else if let button = view as? UIStackView {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorGreenOne)
            }
        }
        transaction?.category = categories![sender.tag-1]
    }
    
    @objc private func createNewCategory(sender:UIButton){
        for view in stackCategoryButtons.arrangedSubviews {
            if let button = view as? UIStackView {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorBG2)
            }
        }
        transaction?.category = nil
    }
    
    @objc private func saveTransaction(){
        
        if transaction?.title == nil || transaction?.category == nil || transaction?.account == nil || transaction?.date == nil || transaction?.type == nil || transaction?.value == nil || transaction?.value == 0.00 {
            
            let alert = UIAlertController(title: "alert_warning".localized(), message: "alert_fill_all_fields".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        
        } else {
            if transaction?.id == nil { transaction?.id = UUID() }
            if transaction?.type == Transaction.TYPE_TRANSACTION_DEBIT { transaction?.value = -transaction!.value }
            formTransactionPresenter.createTransaction()
        }
        
    }
    
}

//MARK: FORMTRANSACTIONPRESENTERPROTOCOL DELEGATE
extension FormTransactionController: FormTransactionPresenterProtocol {
    
    func showError(message: String) {
        
    }
    
    func showSuccess(message: String) {
        dismiss(animated: true)
    }
    
    func presentAccounts(accounts: [Account]) {
        self.accounts = accounts
        self.configAccountButtons()
    }
    
    func presentCategories(categories: [Category]) {
        self.categories = categories
        self.configCategoryButtons()
    }
    
    private func configAccountButtons(){
        if let accounts = accounts {
            for (ind, account) in accounts.enumerated() {
                let button: UIButton
                if let transaction = transaction, transaction.account?.id == account.id {
                    button = .buttonAccount(title: account.title!, textColor: .white, color: UIColor(named: K.colorGreenOne)!)
                }else{
                    button = .buttonAccount(title: account.title!, textColor: .white)
                }
                button.addTarget(self, action: #selector(chooseAccount), for: .touchUpInside)
                button.tag = ind+1
                stackAccountButtons.addArrangedSubview(button)
                stackAccountButtons.distribution = .fillProportionally
            }
            /*let buttonNewAccount: UIButton = .buttonAccount(title: "new_transaction_new_account".localized(), textColor: UIColor(hexString: "#FFFFFF"))
            buttonNewAccount.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
            buttonNewAccount.tag = 0
            stackAccountButtons.addArrangedSubview(buttonNewAccount)*/
        }
    }
    
    private func configCategoryButtons(){
        if let categories = categories {
            
            for (ind, category) in categories.enumerated() {
                let stackButton: UIStackView = UIStackView()
                stackButton.axis = .vertical
                let button: UIButton
                if let transaction = transaction, transaction.category?.id == category.id{
                    button = .roundedSymbolButton(
                        symbolName: category.symbolName!,
                        pointSize: 50,
                        weight: .light,
                        scale: .default,
                        color: UIColor(named: K.colorGreenOne)!,
                        size: .init(width: 60, height: 60),
                        cornerRadius: 30
                    )
                }else{
                    button = .roundedSymbolButton(
                        symbolName: category.symbolName!,
                        pointSize: 50,
                        weight: .light,
                        scale: .default,
                        color: UIColor(named: K.colorBG2)!,
                        size: .init(width: 60, height: 60),
                        cornerRadius: 30
                    )
                }
                
                button.tag = ind+1
                button.addTarget(self, action: #selector(chooseCategory), for: .touchUpInside)
                let titleButton: UILabel = .textLabel(text: category.title!, fontSize: 12, numberOfLines: 1, color: UIColor(named: K.colorText)!)
                titleButton.textAlignment = .center
                stackButton.addArrangedSubview(button)
                stackButton.addArrangedSubview(titleButton)
                stackCategoryButtons.addArrangedSubview(stackButton)
                stackCategoryButtons.distribution = .fill
            }
            /*
            let stackButton: UIStackView = UIStackView()
            stackButton.axis = .vertical
            let titleButton: UILabel = .textLabel(text: "new_transaction_new_category".localized(), fontSize: 12, numberOfLines: 2, color: UIColor(named: K.colorText)!)
            titleButton.textAlignment = .center
            let buttonNewCategory: UIButton = .roundedCustomIconButton(
                imageName: "IconPlus",
                pointSize: 30,
                weight: .light,
                scale: .default,
                color: UIColor(named: K.colorBG2)!,
                size: .init(width: 60, height: 60),
                cornerRadius: 30
            )
            buttonNewCategory.tag = 0
            buttonNewCategory.addTarget(self, action: #selector(createNewCategory), for: .touchUpInside)
            stackButton.addArrangedSubview(buttonNewCategory)
            stackButton.addArrangedSubview(titleButton)
            
            stackCategoryButtons.addArrangedSubview(stackButton)
            stackCategoryButtons.distribution = .fill*/
        }
    }
}

//MARK: TEXTFIELDS DELEGATES
extension FormTransactionController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let strValue = textField.text!
        
        //VALUE
        if textField.tag == 1 {
            self.inputValue.text = strValue.currencyFormat()
            let number = strValue.currencyToDouble()
            if number != 0 {
                transaction?.value = number.doubleValue
            }
        }
        
        //TITLE/DESCRIPTION
        if textField.tag == 2 {
            transaction?.title = strValue
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputValue.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}

