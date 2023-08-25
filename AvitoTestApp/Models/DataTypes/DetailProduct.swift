//
//  DetailProduct.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 25.08.2023.
//

import Foundation

struct DetailProduct: Codable {
    let id: Int
    let title: String
    let price: String
    let location: String
    let image_url: String
    let created_date: String
    let description: String
    let email: String
    let phone_number: String
    let address: String
}
