//
//  EFApiRouter.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import Foundation
import Alamofire
import FileProvider

enum EFApiRouter: URLRequestConvertible {
    
    //MARK: - Search
    ///All the API functions will be listed here
    case search(parameter: [String: Any])

    // MARK: - HTTP Method
    ///API functions will be based on their method and put them in the .get, .post, .put, .delete case
    private var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    // MARK: - Path
    ///The path of the API service will be listed here without the domain
    private var path: String {
        switch self {
        case .search:
            return "services/rest"
        }
    }
    
    // MARK: - Parameters
    ///API functions with parameters will be listed at the return parameters. Otherwise, it will be return nil
    private var parameters: Parameters? {
        switch self {
        case .search(let parameters):
            return parameters
        }
    }
    
    // MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        ///Get the domain
        let url: URL = try Electrolux.apiCredential.baseURL.asURL()
        var urlRequest: URLRequest = URLRequest(url: url.appendingPathComponent(path))
        
        ///Adding the rest of parameters into the path if the HTTP Method is GET
        if method.rawValue == "GET" && parameters != nil {
            if let dict = parameters as? [String: String] {
                if var urlComponents = EFUtil.addQueryParams(url: urlRequest.url!, parameters: dict) {
                    let extras = [
                        URLQueryItem(name: "extras", value: "media"),
                        URLQueryItem(name: "extras", value: "url_sq"),
                        URLQueryItem(name: "extras", value: "url_m")
                    ]
                    urlComponents.queryItems?.append(contentsOf: extras)
                    let completedUrl = urlComponents.url!
                    urlRequest = URLRequest(url: completedUrl)
                } else {
                    urlRequest = URLRequest(url: url.appendingPathComponent(path))
                }
            }
        }
        return urlRequest
    }
}

