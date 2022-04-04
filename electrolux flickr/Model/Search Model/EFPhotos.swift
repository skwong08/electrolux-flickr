//
//  EFPhotos.swift
//
//  Created by Wong Sai Khong on 04/04/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct EFPhotos: Codable {
    enum CodingKeys: String, CodingKey {
        case perpage
        case page
        case photo
        case pages
        case total
    }

    var perpage: Int?
    var page: Int?
    var photo: [EFPhoto]?
    var pages: Int?
    var total: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        perpage = try container.decodeIfPresent(Int.self, forKey: .perpage)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        photo = try container.decodeIfPresent([EFPhoto].self, forKey: .photo)
        pages = try container.decodeIfPresent(Int.self, forKey: .pages)
        total = try container.decodeIfPresent(Int.self, forKey: .total)
    }
}
