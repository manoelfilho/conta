import UIKit

class FilterTransactionController: UIViewController {
    
    private let notificationCenter = TransactionNotifications.shared
    
    private let filter = TransactionsFilter.shared
    
    private let locale: String = Locale.current.regionCode!
        
    private let filterTransactionPresenter: FilterTransactionPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let accountService = AccountService(viewContext: context)
        let categoryService = CategoryService(viewContext: context)
        let filterTransactionPresenter = FilterTransactionPresenter(accountService: accountService, categorySerive: categoryService)
        return filterTransactionPresenter
   }()
    
    private var accounts: [Account]?
    
    private var categories: [Category]?
    
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let stackTopButtons: UIStackView = {
        let stackTopButtons: UIStackView = UIStackView()
        stackTopButtons.distribution = .equalCentering
        stackTopButtons.alignment = .center
        return stackTopButtons
    }()
    
    private let cancellButton:UIButton = {
        let cancellButton: UIButton = UIButton()
        cancellButton.setTitle("new_transaction_cancell".localized(), for: .normal);
        cancellButton.tintColor = UIColor(named: K.colorText)
        return cancellButton
    }()
    
    private let clearButton:UIButton = {
        let clearButton: UIButton = UIButton()
        clearButton.setTitle("new_transaction_clear".localized(), for: .normal);
        clearButton.tintColor = UIColor(named: K.colorText)
        return clearButton
    }()
    
    private let segmentedTypeControll: UISegmentedControl = {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let segmentedTypeControll = UISegmentedControl(items: [ "filter_transaction_all_types".localized(), Transaction.TYPE_TRANSACTION_DEBIT.localized(), Transaction.TYPE_TRANSACTION_CREDIT.localized()])
        segmentedTypeControll.selectedSegmentIndex = 0
        segmentedTypeControll.selectedSegmentTintColor = UIColor(named: K.colorGreenOne)
        segmentedTypeControll.backgroundColor = UIColor(named: K.colorBG2)
        segmentedTypeControll.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedTypeControll.setTitleTextAttributes(titleTextAttributes, for: .selected)
        return segmentedTypeControll
    }()
    
    private let accountLabel: UILabel = {
        let accountsLabel: UILabel = .textLabel(
            text: "new_transaction_account".localized(),
            fontSize: 15,
            numberOfLines: 1,
            color: .white,
            type: .Semibold
        )
        return accountsLabel
    }()
    
    private let categoryLabel: UILabel = {
        let categoryLabel: UILabel = .textLabel(
            text: "new_transaction_category".localized(),
            fontSize: 15,
            numberOfLines: 1,
            color: .white,
            type: .Semibold
        )
        return categoryLabel
    }()
    
    private let wrapperAccountButtons: UIScrollView = {
        let wrapperAccountButtons: UIScrollView = UIScrollView()
        wrapperAccountButtons.showsHorizontalScrollIndicator = false
        wrapperAccountButtons.isDirectionalLockEnabled = true
        return wrapperAccountButtons
    }()
    
    private let stackAccountButtons: UIStackView = {
        let stackAccountButtons: UIStackView = UIStackView()
        stackAccountButtons.spacing = 10
        return stackAccountButtons
    }()
    
    private let wrapperCategoryButtons: UIScrollView = {
        let wrapperCategoryButtons: UIScrollView = UIScrollView()
        wrapperCategoryButtons.showsHorizontalScrollIndicator = false
        wrapperCategoryButtons.isDirectionalLockEnabled = true
        return wrapperCategoryButtons
    }()
    
    private let stackCategoryButtons: UIStackView = {
        let stackCategoryButtons: UIStackView = UIStackView()
        stackCategoryButtons.spacing = 10
        return stackCategoryButtons
    }()
    
    private let filterButton: UIButton = {
        let filterButton: UIButton = UIButton()
        filterButton.backgroundColor = UIColor(named: K.colorGreenOne)
        filterButton.setTitle("filter_transaction_button".localized(), for: .normal)
        filterButton.layer.cornerRadius = 10
        return filterButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTransactionPresenter.setViewDelegate(filterViewDelegate: self)
        
        configView()
        
        filterTransactionPresenter.returnAccounts()
        filterTransactionPresenter.returnCategories()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: Functions
extension FilterTransactionController {
    
    private func configView(){
        
        //MARK: Configs View
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        cancellButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        segmentedTypeControll.addTarget(self, action: #selector(changeType), for: .valueChanged)
        filterButton.addTarget(self, action: #selector(filterTransactions), for: .touchUpInside)
        
        //MARK: Adding Layers
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        stackTopButtons.addArrangedSubview(cancellButton)
        stackTopButtons.addArrangedSubview(clearButton)
        
        contentView.addSubview(stackTopButtons)
        
        contentView.addSubview(segmentedTypeControll)
        contentView.addSubview(accountLabel)
        
        wrapperAccountButtons.addSubview(stackAccountButtons)
        
        contentView.addSubview(wrapperAccountButtons)
        contentView.addSubview(categoryLabel)
        
        wrapperCategoryButtons.addSubview(stackCategoryButtons)
        
        contentView.addSubview(wrapperCategoryButtons)
        contentView.addSubview(filterButton)
        
        //MARK: Constraints
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
        
        stackTopButtons.fill(top: contentView.topAnchor,leading: contentView.leadingAnchor,bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        segmentedTypeControll.fill(top: stackTopButtons.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: 20), size: .init(width: contentView.bounds.width, height: 30))
        
        accountLabel.fill(top: segmentedTypeControll.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: 20))

        wrapperAccountButtons.fill(top: accountLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: contentView.bounds.width, height: 60))
        
        stackAccountButtons.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        categoryLabel.fill(top: stackAccountButtons.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: 20))

        wrapperCategoryButtons.fill(top: categoryLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: contentView.bounds.width, height: 120))

        stackCategoryButtons.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))

        filterButton.fill(top: stackCategoryButtons.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 350, right: 20), size: .init(width: contentView.bounds.width, height: 40))
        
    }
    
    @objc private func dismissController() {
        dismiss(animated: true)
    }
    
    @objc private func clearFilter(){
        filter.clearOptions()
        for view in stackAccountButtons.arrangedSubviews {
            if let button = view as? UIButton {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorBG2)
            }
        }
        for view in stackCategoryButtons.arrangedSubviews {
            if let button = view as? UIStackView {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorBG2)
            }
        }
        _ = try? notificationCenter.postNotification(TransactionsFilter.nameNotification, object: filter.options)
        dismiss(animated: true)
    }
    
    @objc private func chooseAccount(sender:UIButton){
        for view in stackAccountButtons.arrangedSubviews {
            if let button = view as? UIButton, button.tag != sender.tag {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorBG2)
                filter.options["accountId"] = accounts![sender.tag-1].id
            }else if let button = view as? UIButton {
                button.configuration!.baseBackgroundColor = UIColor(named: K.colorGreenOne)
            }
        }
    }
        
    @objc private func chooseCategory(sender:UIButton){
        for view in stackCategoryButtons.arrangedSubviews {
            if let button = view as? UIStackView, button.arrangedSubviews[0].tag != sender.tag {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorBG2)
                filter.options["categoryId"] = categories![sender.tag-1].id
            }else if let button = view as? UIStackView {
                button.arrangedSubviews[0].backgroundColor = UIColor(named: K.colorGreenOne)
            }
        }
    }
        
    @objc private func changeType(){}
    
    @objc private func filterTransactions(){
        _ = try? notificationCenter.postNotification(TransactionsFilter.nameNotification, object: filter.options)
        dismiss(animated: true)
    }
    
}

//MARK: Functions FilterTransactionPresenterProtocol
extension FilterTransactionController: FilterTransactionPresenterProtocol {
    
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
                button = .buttonAccount(title: account.title!, textColor: .white)
                button.addTarget(self, action: #selector(chooseAccount), for: .touchUpInside)
                button.tag = ind+1
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
                let button: UIButton
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
                button.addTarget(self, action: #selector(chooseCategory), for: .touchUpInside)
                let titleButton: UILabel = .textLabel(text: category.title!, fontSize: 12, numberOfLines: 2, color: UIColor(named: K.colorText)!)
                titleButton.textAlignment = .center
                stackButton.addArrangedSubview(button)
                stackButton.addArrangedSubview(titleButton)
                stackCategoryButtons.addArrangedSubview(stackButton)
                stackCategoryButtons.distribution = .fill
            }
            stackCategoryButtons.distribution = .fill
        }
    }
    
}


