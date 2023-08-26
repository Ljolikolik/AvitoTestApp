//
//  Product.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 25.08.2023.
//

import Foundation

struct Product: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let image_url: String
    let created_date: String
}
