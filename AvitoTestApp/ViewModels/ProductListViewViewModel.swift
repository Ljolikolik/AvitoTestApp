//
//  ProductListViewViewModel.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 24.08.2023.
//

import UIKit

protocol ProductListViewViewModelDelegate: AnyObject {
    func didloadProducts()
    func didSelectProduct(_ product: Product)
}

/// View Model to handle product list view logic
final class ProductListViewViewModel: NSObject {
    
    public weak var delegate: ProductListViewViewModelDelegate?
    
    private var products: [Product] = [] {
        didSet {
            for product in products {
                let viewModel = ProductCollectionViewCellViewModel(
                    productTitle: product.title,
                    productPrice: product.price,
                    productLocation: product.location,
                    prductDate: product.created_date,
                    productImageUrl: URL(string: product.image_url)
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [ProductCollectionViewCellViewModel] = []
    
    /// Fetch set of products
    public func fetchProducts() {
        Service.shared.execute(.listProductsRequests,
                               expecting: GetAllProductsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.advertisements
                DispatchQueue.main.async {
                    self?.delegate?.didloadProducts()
                }
                self?.products = results
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

// MARK: - CollectionView

extension ProductListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? ProductCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 1.8
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let product = products[indexPath.row]
        delegate?.didSelectProduct(product)
    }
}
