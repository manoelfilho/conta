import Foundation
import UIKit

protocol SymbolPickerProtocol {
    func didSelectSymbol(symbol: String)
}

class SymbolPicker: UICollectionViewController {
    
    private let symbolNames: [String] = SymbolsCategories.shared.symbolNames
    
    var delegate: SymbolPickerProtocol?
        
    private let cancellButton:UIButton = {
        let cancellButton: UIButton = UIButton()
        cancellButton.setTitle("new_transaction_cancell".localized(), for: .normal);
        cancellButton.tintColor = UIColor(named: K.colorText)
        return cancellButton
    }()
        
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        cancellButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        collectionView.backgroundColor = UIColor(named: K.colorBG1)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        collectionView.register(SymbolCell.self, forCellWithReuseIdentifier: SymbolCell.cellCollectionSymbol)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "collectionViewHeaderCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    @objc func cancel(){
        dismiss(animated: true)
    }
    
}


extension SymbolPicker{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymbolCell.cellCollectionSymbol, for: indexPath) as! SymbolCell
        cell.symbolName = symbolNames[indexPath.row]
        return cell
    }
    
}

extension SymbolPicker: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.bounds.width/5), height: (view.bounds.width/5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "collectionViewHeaderCell", for: indexPath)
        cell.addSubview(self.cancellButton)
        cancellButton.fill(top: cell.topAnchor, leading: nil, bottom: nil, trailing: cell.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        cell.backgroundColor = UIColor(named: K.colorBG1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectSymbol(symbol: symbolNames[indexPath.row])
        dismiss(animated: true)
    }
    
}
