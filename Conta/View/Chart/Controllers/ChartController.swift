import Foundation
import UIKit

class ChartController: UICollectionViewController {
    
    var accounts: [String:[Transaction]] = [:]
    
    private lazy var chartPresenter: ChartPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let accountService: AccountService = AccountService(viewContext: context)
        let homePresenter: ChartPresenter = ChartPresenter(accountService: accountService)
        return homePresenter
    }()
        
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.backgroundColor = UIColor(named: K.colorBG1)
        
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.homeCell)
        collectionView.register(HomeHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCell.homeHeaderCell)
        
        collectionView.showsVerticalScrollIndicator = false
        
        chartPresenter.setViewDelegate(viewDelegate: self)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chartPresenter.returnAccountsGrouped()
    }
    
}

extension ChartController: ChartPresenterProtocol {
    
    func presentAccounts(accounts: [String:[Transaction]]) {
        DispatchQueue.main.async {
            self.accounts = accounts
            self.collectionView.reloadData()
        }
    }
    
    func presentErrorAccounts(message: String) {}
    
}


extension ChartController{
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderCell.homeHeaderCell, for: indexPath) as! HomeHeaderCell
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accounts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.homeCell, for: indexPath) as! HomeCell
        let title = Array(accounts.keys)[indexPath.row]
        cell.title = title
        cell.transactions = accounts[title]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.bounds.width, height: 120)
    }
    
}

extension ChartController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.bounds.width - 40, height: 200 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
