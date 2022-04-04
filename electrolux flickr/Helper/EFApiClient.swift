//
//  EFApiClient.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import Alamofire
import Foundation

class EFApiClient: NSObject {
    @discardableResult
    private static func performRequest<T:Decodable>(route:EFApiRouter, decoder: JSONDecoder = JSONDecoder()) -> Future<T> {
        return Future(operation: { completion in
            if !EFUtil.isConnectedToInternet() {
                completion(.failure("connection offline"))
                return
            }

            AF.request(route).validate()
                .responseDecodable(decoder: decoder, completionHandler: { (response: (AFDataResponse<T>)) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                    
                case .failure(let error):
                    guard let data = response.data else { return completion(.failure(error.localizedDescription)) }
                    do {
                        let apiErrorDetail = try decoder.decode(EFApiError.self, from: data)
                        guard let apiError = apiErrorDetail.error else {
                            guard let apiMessage = apiErrorDetail.message else {
                                return completion(.failure(error.localizedDescription))
                            }
                            return completion(.failure(apiMessage))
                        }
                        completion(.failure(apiError))
                    } catch {
                        completion(.failure("Unexpected error. Please try again."))
                    }
                }
            })
        })
    }
    
    //MARK: - Search
    ///Search API function required to pass the tags and page as param
    ///tags is the search keywords
    ///page is the current page and the max of page will be returned on response
    static func search(tags: String, page: String) -> Future<EFSearchResponse> {
        let parameter = [
            APIParams.apiKey: Electrolux.apiCredential.apiKey,
            APIParams.method: Electrolux.apiCredential.method,
            APIParams.tags: tags,
            APIParams.format: APIValueForParams.format,
            APIParams.noJsonCallback: APIValueForParams.noJsonCallback,
            APIParams.perPage: APIValueForParams.perPage,
            APIParams.page: page
        ] as [String : Any]
        
        return performRequest(route: .search(parameter: parameter))
    }
}

