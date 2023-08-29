//
//  ProductCollectionViewCellViewModel.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 24.08.2023.
//

import Foundation

final class ProductCollectionViewCellViewModel {
    
    public let productTitle: String
    public let productPrice: String
    public let productLocation: String
    public let productDate: String
    public let productImageUrl: URL?

    // MARK: - Init
    
    init(
        productTitle: String,
        productPrice: String,
        productLocation: String,
        productDate: String,
        productImageUrl: URL?
    ) {
        self.productTitle = productTitle
        self.productPrice = productPrice
        self.productLocation = productLocation
        self.productDate = productDate
        self.productImageUrl = productImageUrl
    }
    
//    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
//        guard let url = productImageUrl else {
//            completion(.failure(URLError(.badURL)))
//            return
//        }
//        ImageLoader.shared.downloadImage(url, completion: completion)
//    }
}

