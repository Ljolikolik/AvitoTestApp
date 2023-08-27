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
    public let prductDate: String
    private let productImageUrl: URL?
    
    // MARK: - Init
    
    init(
        productTitle: String,
        productPrice: String,
        productLocation: String,
        prductDate: String,
        productImageUrl: URL?
    ) {
        self.productTitle = productTitle
        self.productPrice = productPrice
        self.productLocation = productLocation
        self.prductDate = prductDate
        self.productImageUrl = productImageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = productImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}

