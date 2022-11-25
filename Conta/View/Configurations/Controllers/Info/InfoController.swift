import Foundation
import UIKit

class InfoController: UIViewController{
    
    private lazy var informations : [String: String] = {
        let options = [
            "app":"app_name",
            "plataform":"app_plataform",
            "developer":"app_developer",
            "version":"app_version"
        ]
        return options
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        headerView.backgroundColor = UIColor(named: K.colorBG1)
        let headerStackView = UIStackView()
        let nameLabel: UILabel = .textLabel(text: "info_title_page".localized(), fontSize: 30, color: .white, type: .Semibold)
        headerStackView.addArrangedSubview(nameLabel)
        headerView.addSubview(headerStackView)
        headerStackView.distribution = .equalCentering
        headerStackView.alignment = .center
        headerStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        return headerView
    }()
    
    private lazy var tableOptions: UITableView = {
        let tableOptions: UITableView = UITableView()
        tableOptions.backgroundColor = UIColor(named: K.colorBG1)
        tableOptions.showsVerticalScrollIndicator = false
        tableOptions.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        tableOptions.register(InfoCell.self, forCellReuseIdentifier: InfoCell.cellInfo)
        return tableOptions
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = ""
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        tableOptions.delegate = self
        tableOptions.dataSource = self
        
        view.addSubview(headerView)
        view.addSubview(tableOptions)
        
        headerView.fill(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 120, left: 0, bottom: 0, right: 0)
        )
        
        tableOptions.fill(
            top: headerView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
}

//MARK: TableView Datasource and Delegate Methods
extension InfoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.informations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = Array(informations.keys)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.cellInfo, for: indexPath) as! InfoCell
        let cellStruct = InfoCellStruct(title: informations[title]?.localized())
        cell.title = cellStruct
        return cell
    }

}
