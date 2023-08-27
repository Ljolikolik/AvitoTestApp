//
//  ProductListViewViewModel.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 24.08.2023.
//

import UIKit

final class ProductListViewViewModel: NSObject {
    func fetchProducts() {
        Service.shared.execute(.listProductsRequests, expecting: GetAllProductsResponse.self) { result in
            switch result {
            case .success(let model):
                print(String(describing: model))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension ProductListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.cellIdentifier, for: indexPath
        ) as? ProductCollectionViewCell else {
            fatalError("Unsupported cell ")
        }
        let viewModel = ProductCollectionViewCellViewModel(productTitle: "Айфон",
                                                           productPrice: "111111",
                                                           productLocation: "jsdnfjsdnf",
                                                           prductDate: "sfdsfs",
                                                           productImageUrl: URL(string: "https://www.avito.st/s/interns-ios/images/2.png"))
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width,
                      height: width * 1.8)
    }
}
