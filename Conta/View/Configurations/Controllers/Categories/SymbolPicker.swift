import Foundation
import UIKit

protocol SymbolPickerProtocol {
    func didSelectSymbol(symbol: String)
}

class SymbolPicker: UIViewController {
    
    private var symbolNames: [String] = SymbolsCategories.shared.symbolNames
    
    var delegate: SymbolPickerProtocol?
        
    private let cancellButton:UIButton = {
        let cancellButton: UIButton = UIButton()
        cancellButton.setTitle("new_transaction_cancell".localized(), for: .normal);
        cancellButton.tintColor = UIColor(named: K.colorText)
        return cancellButton
    }()
    
    private let searchTextField: UITextField = {
        let searchTextField: UITextField = CustomTextField()
        searchTextField.backgroundColor = UIColor(named: K.colorBG3)
        searchTextField.layer.cornerRadius = 10
        searchTextField.textColor = UIColor(named: K.colorText)
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "symbolpicker_search".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.colorText)!]
        )
        return searchTextField
    }()
    
    private let stackCollectionSymbols: UIStackView = {
        let stackCollectionSymbols: UIStackView = UIStackView()
        return stackCollectionSymbols
    }()
    
    private var collectionSymbols: UICollectionView = {
        let collectionSymbols: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionSymbols.showsHorizontalScrollIndicator = false
        collectionSymbols.register(SymbolCell.self, forCellWithReuseIdentifier: SymbolCell.cellCollectionSymbol)
        collectionSymbols.backgroundColor = UIColor(named: K.colorBG1)
        return collectionSymbols
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Notification Center Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = UIColor(named: K.colorBG1)
        
        view.addSubview(cancellButton)
        view.addSubview(searchTextField)
        stackCollectionSymbols.addArrangedSubview(collectionSymbols)
        view.addSubview(stackCollectionSymbols)
        
        cancellButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        cancellButton.fill(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 20, right: 20))
        searchTextField.fill(top: cancellButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        stackCollectionSymbols.fill(top: searchTextField.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        collectionSymbols.fillSuperview()
        
        searchTextField.delegate = self
        collectionSymbols.dataSource = self
        collectionSymbols.delegate = self
        
    }
    
    @objc func cancel(){
        dismiss(animated: true)
    }
    
}

extension SymbolPicker: SymbolCellProtocol{
    func didClickSymbol(symbol: String) {
        self.delegate?.didSelectSymbol(symbol: symbol)
        dismiss(animated: true)
    }
}


extension SymbolPicker: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymbolCell.cellCollectionSymbol, for: indexPath) as! SymbolCell
        cell.symbolName = symbolNames[indexPath.row]
        cell.delegate = self
        return cell
    }
    
}

extension SymbolPicker: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.bounds.width/7), height: (view.bounds.width/7))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectSymbol(symbol: symbolNames[indexPath.row])
        dismiss(animated: true)
    }
    
}

extension SymbolPicker: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            
            if text.count >= 3 {
                let filteredSymbols = self.symbolNames.filter { $0.range(of: text, options: [ .caseInsensitive, .anchored ]) != nil }
                self.symbolNames = filteredSymbols
                self.collectionSymbols.reloadData()
            } else {
                self.symbolNames = SymbolsCategories.shared.symbolNames
                self.collectionSymbols.reloadData()
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}


extension SymbolPicker{
    
    @objc func keyboardDidShown (_ aNotification: Notification) {
        
    }

    @objc func keyboardWillBeHidden (_ aNotification: Notification) {
        
    }
    
}
