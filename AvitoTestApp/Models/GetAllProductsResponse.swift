//
//  GetAllProductsResponse.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 26.08.2023.
//

import Foundation

struct GetAllProductsResponse: Codable {
    let advertisements: [Product]
}

struct Product: Codable {
    let id, title, price, location: String
    let imageURL: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
    }
}
