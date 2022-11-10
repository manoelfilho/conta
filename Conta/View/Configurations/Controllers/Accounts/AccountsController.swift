import Foundation
import UIKit

class AccountsController: UIViewController {
    
    var filter: AccountsFilter = AccountsFilter.shared
    
    private lazy var accounts: [Account] = []
    
    private lazy var accountsPresenter: AccountsPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let accountService: AccountService = AccountService(viewContext: context)
        let accountsPresenter: AccountsPresenter = AccountsPresenter(accountService: accountService)
        return accountsPresenter
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        headerView.backgroundColor = UIColor(named: K.colorBG1)
        let headerStackView = UIStackView()
        let nameLabel: UILabel = .textLabel(text: "accounts_title_page".localized(), fontSize: 30, color: .white, type: .Semibold)
        let userImage = UIImageView(image: UIImage(named: "icon_wallet"))
        headerStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(userImage)
        headerView.addSubview(headerStackView)
        headerStackView.distribution = .equalCentering
        headerStackView.alignment = .center
        headerStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        return headerView
    }()
    
    private lazy var tableAccounts: UITableView = {
        let tableAccounts: UITableView = UITableView()
        tableAccounts.register(AccountCell.self, forCellReuseIdentifier: AccountCell.cellAccount)
        tableAccounts.backgroundColor = UIColor(named: K.colorBG1)
        tableAccounts.showsVerticalScrollIndicator = false
        tableAccounts.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        return tableAccounts
    }()
    
    private lazy var buttonAdd: UIButton = {
        let buttonAdd: UIButton = .roundedCustomIconButton(
            imageName: "IconPlus",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: UIColor(named: K.colorGreenOne)!,
            size: .init(width: 60, height: 60),
            cornerRadius: 30
        )
        return buttonAdd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        accountsPresenter.setViewDelegate(accountServiceDelegate: self)
        
        tableAccounts.delegate = self
        tableAccounts.dataSource = self
        
        configView()
        
        accountsPresenter.returnAccounts(filter: self.filter.options)
        
    }
    
    private func configView(){
        
        tabBarController?.tabBar.isHidden = true
        
        buttonAdd.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        
        view.addSubview(headerView)
        view.addSubview(tableAccounts)
        view.addSubview(buttonAdd)
        
        headerView.fill(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 120, left: 0, bottom: 0, right: 0))
        tableAccounts.fill(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        buttonAdd.fill(top: nil, leading: nil, bottom: view.bottomAnchor,trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 120, right: 20))
    
    }
    
    @objc func addAccount(){
        let accountForm = FormAccountController()
        accountForm.setViewDelegate(formAccountControllerDelegate: self)
        let account: Account = Account(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        account.color = "#96A7AF"
        accountForm.account = account
        accountForm.modalTransitionStyle = .coverVertical
        present(accountForm, animated: true, completion: nil)
    }
    
}

extension AccountsController: FormAccountControllerProtocol{
    
    func didCloseFormAccount() {
        accountsPresenter.returnAccounts(filter: filter.options)
    }
    
}

extension AccountsController: AccountsPresenterProtocol {
    
    func presentAccounts(accounts: [Account]) {
        self.accounts = accounts
        self.tableAccounts.reloadData()
    }
    
    func presentErrorAccounts(message: String) {}
    
    func presentSuccessRemovingAccount(message: String) {}
    
}

//MARK: TABLEVIEW DELEGATE
extension AccountsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accountForm = FormAccountController()
        accountForm.setViewDelegate(formAccountControllerDelegate: self)
        accountForm.modalTransitionStyle = .coverVertical
        accountForm.account = accounts[indexPath.row]
        present(accountForm, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountCell.cellAccount, for: indexPath) as! AccountCell
        cell.accountCell = AccountCellModel(
            title: self.accounts[indexPath.row].title,
            color: self.accounts[indexPath.row].color
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = UIContextualAction(style: .destructive, title: "delete_transaction".localized()) { (action, vieew, completionHandler) in
            
            let dialogMessage = UIAlertController(title: "alert_warning".localized(), message: "confirm_removal_account".localized(), preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "confirm_removal_ok".localized(), style: .default, handler: { (action) -> Void in
                self.accountsPresenter.removeAccount(self.accounts[indexPath.row])
                self.accounts.remove(at: indexPath.row)
                self.accountsPresenter.returnAccounts(filter: self.filter.options)
            })
            
            let cancel = UIAlertAction(title: "confirm_removal_not".localized(), style: .cancel) { (action) -> Void in }
            
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
        
        trash.image = UIImage(named: "trash")
        trash.backgroundColor = UIColor(named: K.colorRedOne)
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
        
    }
    
}
