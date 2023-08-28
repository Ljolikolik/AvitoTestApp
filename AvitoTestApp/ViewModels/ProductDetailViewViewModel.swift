//
//  ProductDetailViewViewModel.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 28.08.2023.
//

import Foundation

final class ProductDetailViewViewModel {
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    public var title: String {
        product.title.uppercased()
    }
}
