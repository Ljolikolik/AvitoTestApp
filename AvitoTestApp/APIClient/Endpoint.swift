//
//  Endpoint.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 25.08.2023.
//

import Foundation

/// Represents unique API endpoint
@frozen enum Endpoint: String, CaseIterable, Hashable {
    /// Endpoint to get product info
    case mainPage = "main-page"
    /// Endpoint to get detail product info
    case details
}
