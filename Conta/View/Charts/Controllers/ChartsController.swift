import Foundation
import UIKit

class ChartsController: UICollectionViewController {
    
    var accounts: [String:[Transaction]] = [:]
    
    private lazy var chartPresenter: ChartsPresenter = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let accountService: AccountService = AccountService(viewContext: context)
        let chartPresenter: ChartsPresenter = ChartsPresenter(accountService: accountService)
        return chartPresenter
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
        chartPresenter.setViewDelegate(viewDelegate: self)
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chartPresenter.returnAccountsGrouped()
    }
    
    func configView() {
        collectionView.backgroundColor = UIColor(named: K.colorBG1)
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.chartCell)
        collectionView.register(HeaderChartsController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderChartsController.homeHeaderCell)
        collectionView.showsVerticalScrollIndicator = false
    }
    
}

extension ChartsController: ChartsPresenterProtocol {
    
    func presentAccounts(accounts: [String:[Transaction]]) {
        DispatchQueue.main.async {
            self.accounts = accounts
            self.collectionView.reloadData()
        }
    }
    
    func presentErrorAccounts(message: String) {}
    
}

extension ChartsController: ChartCellDelegate {
    func showDetails(account: String, transactions: [Transaction]) {
        let chartDetailController = ChartDetailController()
        
        chartDetailController.chartDetailView.transactions = transactions
        chartDetailController.titlePage = account
        chartDetailController.transactions = transactions
        
        chartDetailController.modalPresentationStyle = .fullScreen
        present(chartDetailController, animated: true, completion: nil)
    }
}


extension ChartsController{
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderChartsController.homeHeaderCell, for: indexPath) as! HeaderChartsController
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accounts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.chartCell, for: indexPath) as! ChartCell
        cell.setViewDelegate(chartCellDelegate: self)
        let title = Array(accounts.keys)[indexPath.row]
        cell.title = title
        cell.transactions = accounts[title]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.bounds.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

    
}

extension ChartsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.bounds.width - 40, height: 200 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
