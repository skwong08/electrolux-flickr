//
//  EFSearchResponse.swift
//
//  Created by Wong Sai Khong on 04/04/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct EFSearchResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case stat
        case photos
    }

    var stat: String?
    var photos: EFPhotos?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stat = try container.decodeIfPresent(String.self, forKey: .stat)
        photos = try container.decodeIfPresent(EFPhotos.self, forKey: .photos)
    }
}
