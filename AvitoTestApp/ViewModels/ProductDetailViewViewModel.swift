//
//  ProductDetailViewViewModel.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 28.08.2023.
//

import UIKit

protocol ProductDetailsViewViewModelDelegate : AnyObject {
    func didLoadDetails(details: DetailProduct)
}

final class ProductDetailViewViewModel {
    let product: Product
    var details: DetailProduct? = nil
    public weak var delegate: ProductDetailsViewViewModelDelegate?

    // MARK: - Init

    init(product: Product) {
        self.product = product
    }
    
    private var productId: String {
        product.id
    }
    
    public var imageURL: URL? {
        return URL(string: product.imageURL)
    }
    
    public var title: String {
        product.title
    }
    
    public var price: String {
        product.price
    }
    
    public func fetchProductData() {
        Service.shared.execute(Request(endpoint: .details, pathComponents: ["\(productId).json"]),
                               expecting: DetailProduct.self) { result in
            switch result {
            case .success(let responseModel):
                self.details = responseModel
                DispatchQueue.main.async {
                    self.delegate?.didLoadDetails(details: responseModel)
                }
                //print(String(describing: success))
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
}
