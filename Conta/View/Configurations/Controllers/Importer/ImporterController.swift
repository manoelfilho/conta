import Foundation
import UIKit
import MobileCoreServices

class ImporterController: UIViewController{
    
    private lazy var filter:TransactionsFilter = TransactionsFilter.shared
    
    private lazy var filterTransactionPresenter: FilterTransactionPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let accountService = AccountService(viewContext: context)
        let categoryService = CategoryService(viewContext: context)
        let filterTransactionPresenter = FilterTransactionPresenter(accountService: accountService, categorySerive: categoryService)
        return filterTransactionPresenter
    }()
    
    private lazy var headerView: UILabel = {
        let nameLabel: UILabel = .textLabel(text: "importer".localized(), fontSize: 30, color: .white, type: .Semibold)
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let labelFooter: UILabel = .textLabel(text: "description_import_label".localized(), fontSize: 15, numberOfLines: 6, color: UIColor(named: K.colorText)!, type: .Light)
        labelFooter.textAlignment = .natural
        return labelFooter
    }()
    
    private lazy var selectFileButton: UIButton = {
        let filterButton: UIButton = UIButton()
        filterButton.backgroundColor = UIColor(named: K.colorBG2)
        filterButton.setTitle("import_file_transactions_button".localized(), for: .normal)
        filterButton.layer.cornerRadius = 10
        return filterButton
    }()
    
    private var accounts: [Account]?
    
    private var categories: [Category]?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView = UIView()
    
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
    
    private lazy var importButton: UIButton = {
        let filterButton: UIButton = UIButton()
        filterButton.backgroundColor = UIColor(named: K.colorBG4)
        filterButton.setTitle("import_transactions_button".localized(), for: .normal)
        filterButton.layer.cornerRadius = 10
        filterButton.isEnabled = false
        return filterButton
    }()
    
    
    private var urls: [URL]?
    
    private var firstFileURL: URL?
    
    private var fileExtension: String?
    
    private var fileName: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        filterTransactionPresenter.setViewDelegate(filterViewDelegate: self)
        
        configView()
        
        filterTransactionPresenter.returnAccounts()
        filterTransactionPresenter.returnCategories()
        
    }
    
}

//MARK: PRESENT FUNCTIONS
extension ImporterController: UIDocumentPickerDelegate {
    
    @objc func goToDocumentSelectController(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
            documentPicker.delegate = self
            documentPicker.modalTransitionStyle = .coverVertical
            present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if urls[0].description.fileExtension() == "ofx"{
            
            self.urls = urls
            self.firstFileURL = urls[0]
            self.fileName = urls[0].description.fileName()
            self.fileExtension = urls[0].description.fileExtension()
            
            self.selectFileButton.setTitle("\(urls[0].description.fileName()).ofx", for: .normal)
            self.importButton.isEnabled = true
            self.importButton.backgroundColor = UIColor(named: K.colorGreenOne)
            
        } else {
            
            self.urls = nil
            self.firstFileURL = nil
            self.fileName = nil
            self.fileExtension = nil
            
            self.selectFileButton.setTitle("invalid_file_text".localized(), for: .normal)
            self.importButton.isEnabled = false
            self.importButton.backgroundColor = UIColor(named: K.colorBG4)
        }
        
        //navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func importFile(){
        
        if  let firstFileURL = self.firstFileURL {
           
            let isSecuredURL = (firstFileURL.startAccessingSecurityScopedResource() == true)
            
            var blockSuccess = false
            var outputFileURL: URL? = nil
            
            let coordinator = NSFileCoordinator()
            var error: NSError? = nil
            
            coordinator.coordinate(readingItemAt: firstFileURL, options: [], error: &error) { (externalFileURL) -> Void in
                 
                var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                tempURL.appendPathComponent(externalFileURL.lastPathComponent)
                //print("Will attempt to copy file to tempURL = \(tempURL)")
                
                do {
                    
                    if FileManager.default.fileExists(atPath: tempURL.path) {
                        //print("Deleting existing file at: \(tempURL.path) ")
                        try FileManager.default.removeItem(atPath: tempURL.path)
                    }
                    
                    //print("Attempting move file to: \(tempURL.path) ")
                    try FileManager.default.moveItem(atPath: externalFileURL.path, toPath: tempURL.path)
                    
                    blockSuccess = true
                    outputFileURL = tempURL
                    
                    let fileData = try String(contentsOf: tempURL)
                    print(fileData)
                    
                }
                
                catch {
                    print("File operation error: " + error.localizedDescription)
                    blockSuccess = false
                }
                
            }
            
        }
        
    }

}

extension ImporterController {
    
    private func configView(){
        
        tabBarController?.tabBar.isHidden = true
        
        //MARK: VIEW CONFIGURATION
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        //MARK: ACTIONS OF BUTTONS
        selectFileButton.addTarget(self, action: #selector(self.goToDocumentSelectController), for: .touchUpInside);
        importButton.addTarget(self, action: #selector(self.importFile), for: .touchUpInside);
        
        //MARK: LAYERS AND CONSTRAINTS
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(selectFileButton)
        
        contentView.addSubview(accountLabel)
        
        wrapperAccountButtons.addSubview(stackAccountButtons)
        
        contentView.addSubview(wrapperAccountButtons)
        contentView.addSubview(categoryLabel)
        
        wrapperCategoryButtons.addSubview(stackCategoryButtons)
        
        contentView.addSubview(wrapperCategoryButtons)
        contentView.addSubview(importButton)
        
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
        
        headerView.fill(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 20, bottom: 0, right: 20)
        )
        
        descriptionLabel.fill(
                top: headerView.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil, trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 20, bottom: 0, right: 20)
        )
        
        selectFileButton.fill(
                top: descriptionLabel.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil, trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 20, bottom: 0, right: 20)
        )
        
        accountLabel.fill(
                top: selectFileButton.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil, trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 20, bottom: 0, right: 20)
        )

        wrapperAccountButtons.fill(
                top: accountLabel.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil, trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: contentView.bounds.width, height: 60)
        )

        stackAccountButtons.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))

        categoryLabel.fill(
                top: stackAccountButtons.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil, trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 20, bottom: 0, right: 20)
        )

        wrapperCategoryButtons.fill(
                top: categoryLabel.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: nil, trailing: contentView.trailingAnchor,
                padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: contentView.bounds.width, height: 120)
        )

        stackCategoryButtons.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))

        importButton.fill(
                top: stackCategoryButtons.bottomAnchor,
                leading: contentView.leadingAnchor,
                bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,
                padding: .init(top: 20, left: 20, bottom: 350, right: 20), size: .init(width: contentView.bounds.width, height: 40)
        )
        
    }
}


//MARK: FILTERTRANSACTIONPRESENTERPROTOCOL DELEGATE
extension ImporterController: FilterTransactionPresenterProtocol {
    
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
                let button: CustomButton
                button = .buttonAccount(title: account.title!, textColor: .white)
                button.addTarget(self, action: #selector(chooseAccount), for: .touchUpInside)
                button.tag = ind+1
                button.uuid = account.id
                if let accountId = filter.options["accountId"] as? UUID {
                    button.configuration!.baseBackgroundColor = accountId == account.id ? UIColor(named: K.colorGreenOne)! : UIColor(named: K.colorBG2)!
                }
                stackAccountButtons.addArrangedSubview(button)
                stackAccountButtons.distribution = .fillProportionally
            }
        }
    }
    
    private func configCategoryButtons(){
        if let categories = categories {
            for (ind, category) in categories.enumerated() {
                let stackButton: UIStackView = UIStackView()
                stackButton.axis = .vertical
                let button: CustomButton
                button = .roundedSymbolButton(
                    symbolName: category.symbolName!,
                    pointSize: 50,
                    weight: .light,
                    scale: .default,
                    color: UIColor(named: K.colorBG2)!,
                    size: .init(width: 60, height: 60),
                    cornerRadius: 30
                )
                button.tag = ind+1
                button.uuid = category.id
                button.addTarget(self, action: #selector(chooseCategory), for: .touchUpInside)
                let titleButton: UILabel = .textLabel(text: category.title!, fontSize: 12, numberOfLines: 1, color: UIColor(named: K.colorText)!)
                titleButton.textAlignment = .center
                stackButton.addArrangedSubview(button)
                stackButton.addArrangedSubview(titleButton)
                
                if let categoryId = filter.options["categoryId"] as? UUID {
                    button.backgroundColor = categoryId == category.id ? UIColor(named: K.colorGreenOne)! : UIColor(named: K.colorBG2)!
                }
                
                stackCategoryButtons.addArrangedSubview(stackButton)
                stackCategoryButtons.distribution = .fill
            }
            stackCategoryButtons.distribution = .fill
        }
    }
    
    @objc private func chooseAccount(sender:UIButton){
        for view in stackAccountButtons.arrangedSubviews {
            if let button = view as? UIButton, button.tag != sender.tag {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorBG2)
                
                //Ao selecionar conta ...
                
            }else if let button = view as? UIButton {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorGreenOne)
            }
        }
    }
    
    @objc private func chooseCategory(sender:UIButton){
        for view in stackCategoryButtons.arrangedSubviews {
            if let button = view as? UIStackView, button.arrangedSubviews[0].tag != sender.tag {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorBG2)
                
                //Ao selecionar categoria ...
                
            }else if let button = view as? UIStackView {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorGreenOne)
            }
        }
    }
    
}
