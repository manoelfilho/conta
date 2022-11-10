import Foundation
import UIKit

class ConfigurationsController: UIViewController{
    
    private lazy var optionsTable: [String:String] = [
        "person":"configurations_personal_data",
        "wallet.pass":"configurations_account",
        "tag":"configurations_categories",
        "gear":"configurations_import"
    ]
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        headerView.backgroundColor = UIColor(named: K.colorBG1)
        let headerStackView = UIStackView()
        let nameLabel: UILabel = .textLabel(text: "configurations_title_page".localized(), fontSize: 30, color: .white, type: .Semibold)
        let userImage = UIImageView(image: UIImage(named: "user"))
        headerStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(userImage)
        headerView.addSubview(headerStackView)
        headerStackView.distribution = .equalCentering
        headerStackView.alignment = .center
        headerStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        return headerView
    }()
    
    private lazy var tableOptions: UITableView = {
        let tableOptions: UITableView = UITableView()
        tableOptions.register(ConfigurationCell.self, forCellReuseIdentifier: ConfigurationCell.cellConfiguration)
        tableOptions.backgroundColor = UIColor(named: K.colorBG1)
        tableOptions.showsVerticalScrollIndicator = false
        tableOptions.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        return tableOptions
    }()
    
    private lazy var footerView: UIView = {
        let footer: UIView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        return footer
    }()
    
    private lazy var labelFooter: UILabel = {
        let labelFooter: UILabel = .textLabel(text: "label_foot_configurations".localized(), fontSize: 15, numberOfLines: 4, color: UIColor(named: K.colorText)!, type: .Light)
        labelFooter.textAlignment = .center
        return labelFooter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        tableOptions.delegate = self
        tableOptions.dataSource = self
        
        view.addSubview(headerView)
        view.addSubview(tableOptions)
        footerView.addSubview(labelFooter)
        view.addSubview(footerView)
        
        headerView.fill(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 120, left: 0, bottom: 0, right: 0))
        tableOptions.fill(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        footerView.fill(top: tableOptions.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        labelFooter.fillSuperview(padding: .init(top: 0, left: 25, bottom: 25, right: 25))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
}

//MARK: TableView Datasource and Delegate Methods
extension ConfigurationsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let authRegister = AuthRegisterController()
            authRegister.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(authRegister, animated: true)
            
        case 1:
            let accountsController = AccountsController()
            accountsController.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(accountsController, animated: true)
            
        case 2:
            let categoriesController = CategoriesController()
            categoriesController.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(categoriesController, animated: true)
            
        default:
            let importerController = ImporterController()
            importerController.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(importerController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionsTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConfigurationCell.cellConfiguration, for: indexPath) as! ConfigurationCell
        switch indexPath.row {
            case 0:
                cell.configCell = ConfigCell(title: self.optionsTable["person"]?.localized(), symbolName: "person.fill", color: "#3ED598")
            case 1:
                cell.configCell = ConfigCell(title: self.optionsTable["wallet.pass"]?.localized(), symbolName: "wallet.pass.fill", color: "#FF565E")
            case 2:
                cell.configCell = ConfigCell(title: self.optionsTable["tag"]?.localized(), symbolName: "tag.fill", color: "#FFC542")
            case 3:
                cell.configCell = ConfigCell(title: self.optionsTable["gear"]?.localized(), symbolName: "gear", color: "#005DF2")
            default:
                cell.configCell = ConfigCell(title: self.optionsTable["person"]?.localized(), symbolName: "person", color: "#FF565E")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
