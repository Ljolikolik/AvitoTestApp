//
//  ProductListView.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 24.08.2023.
//

import UIKit

protocol ProductListViewDelegate: AnyObject {
    func productListView(
        _ productListView: ProductListView,
        didSelectProduct product: Product
    )
}



/// View that handles showing list of products, loader, etc.
final class ProductListView: UIView {
    
    public weak var delegate: ProductListViewDelegate?
    
    private let viewModel = ProductListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func showRetryButton(retryAction: @escaping () -> Void) {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.setTitle("Retry", for: .normal)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
        
        // Store the retry action in the button's tag to access it in the selector
        button.tag = 1
        objc_setAssociatedObject(button, &retryActionKey, retryAction, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    @objc func retry(_ sender: UIButton) {
        // Retrieve the stored retry action from the button's associated object
        if let retryAction = objc_getAssociatedObject(sender, &retryActionKey) as? () -> Void {
            retryAction()
        }
        
        sender.removeFromSuperview()
    }

    private var retryActionKey: UInt8 = 0
    
    func showSnackbar(message: String) {
            let snackbarView = UIView()
            snackbarView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            snackbarView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(snackbarView)
            
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            snackbarView.addSubview(label)
            
            NSLayoutConstraint.activate([
                snackbarView.leadingAnchor.constraint(equalTo: leadingAnchor),
                snackbarView.trailingAnchor.constraint(equalTo: trailingAnchor),
                snackbarView.bottomAnchor.constraint(equalTo: bottomAnchor),
                snackbarView.heightAnchor.constraint(equalToConstant: 44), // Adjust the height as needed
                
                label.leadingAnchor.constraint(equalTo: snackbarView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: snackbarView.trailingAnchor, constant: -16),
                label.topAnchor.constraint(equalTo: snackbarView.topAnchor),
                label.bottomAnchor.constraint(equalTo: snackbarView.bottomAnchor)
            ])
            
        //появление
            UIView.animate(withDuration: 0.3, animations: {
                snackbarView.transform = CGAffineTransform(translationX: 0, y: -snackbarView.frame.height)
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.3) {
                        snackbarView.transform = .identity
                    }
                }
            }
        //исчезновение
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.8, animations: {
                snackbarView.alpha = 0.0
            }) { _ in
                snackbarView.removeFromSuperview()
            }
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    // MARK - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(spinner, collectionView)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        setupCollectionView()
        viewModel.fetchProducts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension ProductListView: ProductListViewViewModelDelegate {
    func errorHasBeenOccured(message: String) {
        showSnackbar(message: message)
        spinner.stopAnimating()
        showRetryButton(retryAction: {
            self.viewModel.fetchProducts()
        })
    }
    
    func didSelectProduct(_ product: Product) {
        delegate?.productListView(self, didSelectProduct: product)
    }
    
    func didloadProducts() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
