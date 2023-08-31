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
    
    private let retryButton: RetryButton = {
        let retryButton = RetryButton()
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return retryButton
    }()
    
    private let snackbarView: SnackbarView = {
        let snackbarView = SnackbarView()
        snackbarView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        snackbarView.translatesAutoresizingMaskIntoConstraints = false
        return snackbarView
    }()
    
    private func retry() {
        retryButton.hide()
        spinner.startAnimating()
        viewModel.fetchProducts()
        
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
        addSubviews(spinner, retryButton, collectionView, snackbarView)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        setupCollectionView()
        viewModel.fetchProducts()
        retryButton.setRetryAction(retryAction: retry)
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
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
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
        snackbarView.show(root: self, message: message)
        spinner.stopAnimating()
        retryButton.show()
    }
    
    func didSelectProduct(_ product: Product) {
        delegate?.productListView(self, didSelectProduct: product)
    }
    
    func didloadProducts() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        retryButton.hide()
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
