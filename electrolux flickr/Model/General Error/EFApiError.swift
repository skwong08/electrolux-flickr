//
//  EFApiError.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import Foundation

struct EFApiError: Codable {
    var error: String?
    var errorDesc: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDesc = "error_description"
        case message
    }
}
