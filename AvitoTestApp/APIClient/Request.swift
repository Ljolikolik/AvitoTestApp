//
//  Request.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 24.08.2023.
//

import Foundation

/// Object that represents a singlet API call
final class Request {
    
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://www.avito.st/s/interns-ios"
    }
    
    /// Desired andpoint
    private let endpoint: Endpoint
    
    /// Path components for API,  if any
    private let pathComponents: [String]
    
    /// Constructed urlfor the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        return string
    }
    
    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    // MARK: - Public
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: target endpoint
    ///   - pathComponents: collection of Path components
    public init(
        endpoint: Endpoint,
        pathComponents: [String] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
    }
}

extension Request {
    static let listProductsRequests = Request(endpoint: .mainPage)
}
