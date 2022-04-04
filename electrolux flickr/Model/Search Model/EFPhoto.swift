//
//  EFPhoto.swift
//
//  Created by Wong Sai Khong on 04/04/2022.
//  Copyright (c) . All rights reserved.
//

import Foundation

struct EFPhoto: Codable {
    enum CodingKeys: String, CodingKey {
        case owner
        case id
        case urlM = "url_m"
        case server
        case farm
        case title
        case secret
        case isfamily
        case ispublic
        case heightM = "height_m"
        case widthM = "width_m"
        case isfriend
    }

    var owner: String?
    var id: String?
    var urlM: String?
    var server: String?
    var farm: Int?
    var title: String?
    var secret: String?
    var isfamily: Int?
    var ispublic: Int?
    var heightM: Int?
    var widthM: Int?
    var isfriend: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        owner = try container.decodeIfPresent(String.self, forKey: .owner)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        urlM = try container.decodeIfPresent(String.self, forKey: .urlM)
        server = try container.decodeIfPresent(String.self, forKey: .server)
        farm = try container.decodeIfPresent(Int.self, forKey: .farm)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        secret = try container.decodeIfPresent(String.self, forKey: .secret)
        isfamily = try container.decodeIfPresent(Int.self, forKey: .isfamily)
        ispublic = try container.decodeIfPresent(Int.self, forKey: .ispublic)
        heightM = try container.decodeIfPresent(Int.self, forKey: .heightM)
        widthM = try container.decodeIfPresent(Int.self, forKey: .widthM)
        isfriend = try container.decodeIfPresent(Int.self, forKey: .isfriend)
    }
}
