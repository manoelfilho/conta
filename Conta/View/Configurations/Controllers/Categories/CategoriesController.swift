import Foundation
import UIKit

class CategoriesController: UIViewController {
    
    var filter: CategoriesFilter = CategoriesFilter.shared
    
    private var categories: [Category] = []
    
    private let categoriesPresenter: CategoriesPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let categoryService: CategoryService = CategoryService(viewContext: context)
        let categoriesPresenter: CategoriesPresenter = CategoriesPresenter(categoryService: categoryService)
        return categoriesPresenter
    }()
    
    private let headerView: UIView = {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        headerView.backgroundColor = UIColor(named: K.colorBG1)
        let headerStackView = UIStackView()
        let nameLabel: UILabel = .textLabel(text: "categories_title_page".localized(), fontSize: 30, color: .white, type: .Semibold)
        let userImage = UIImageView(image: UIImage(named: "icon_tag"))
        headerStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(userImage)
        headerView.addSubview(headerStackView)
        headerStackView.distribution = .equalCentering
        headerStackView.alignment = .center
        headerStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        return headerView
    }()
    
    private let tableCategories: UITableView = {
        let tableCategories: UITableView = UITableView()
        tableCategories.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.cellCategory)
        tableCategories.backgroundColor = UIColor(named: K.colorBG1)
        tableCategories.showsVerticalScrollIndicator = false
        tableCategories.separatorColor = UIColor(named: K.colorText)?.withAlphaComponent(0.3)
        return tableCategories
    }()
    
    private var buttonAdd: UIButton = {
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
        
        categoriesPresenter.setViewDelegate(categoryServiceDelegate: self)
        
        tableCategories.delegate = self
        tableCategories.dataSource = self
        
        configView()
        
        categoriesPresenter.returnCategories(filter: filter.options)
        
    }
    
    private func configView(){
        
        buttonAdd.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
        view.addSubview(headerView)
        view.addSubview(tableCategories)
        view.addSubview(buttonAdd)
        
        headerView.fill(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 120, left: 0, bottom: 0, right: 0))
        tableCategories.fill(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        buttonAdd.fill(top: nil, leading: nil, bottom: view.bottomAnchor,trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 50, right: 20))
    
    }
    
    @objc func addCategory(){
        let categoryForm = FormCategoryController()
        categoryForm.setViewDelegate(formCategoryControllerDelegate: self)
        let category: Category = Category(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        categoryForm.category = category
        categoryForm.modalTransitionStyle = .coverVertical
        present(categoryForm, animated: true, completion: nil)
    }
    
}

extension CategoriesController: FormCategoryControllerProtocol{
    func didCloseFormCategory() {
        categoriesPresenter.returnCategories(filter: filter.options)
    }
}

extension CategoriesController: CategoriesPresenterProtocol {
    
    func presentCategories(categories: [Category]) {
        self.categories = categories
        self.tableCategories.reloadData()
    }
    
    func presentErrorCategories(message: String) {}
    
}

//MARK: TableView Datasource and Delegate Methods
extension CategoriesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryForm = FormCategoryController()
        categoryForm.setViewDelegate(formCategoryControllerDelegate: self)
        categoryForm.modalTransitionStyle = .coverVertical
        categoryForm.category = categories[indexPath.row]
        present(categoryForm, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellCategory, for: indexPath) as! CategoryCell
        cell.categoryCell = CategoryCellModel(
            title: categories[indexPath.row].title,
            symbolName: categories[indexPath.row].symbolName
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
