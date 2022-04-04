//
//  EFConstant.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import Foundation
import UIKit

struct ConstantSize {
    static let paddingStandard = EFUtil.convertSizeByDensity(size: 16)
    static let paddingStandardDouble = paddingStandard * 2
    static let paddingStandardHalf = paddingStandard / 2
    
    static let paddingSecondary = EFUtil.convertSizeByDensity(size: 24)
    static let paddingSecondaryDouble = paddingSecondary * 2
    static let paddingSecondaryHalf = paddingSecondary / 2
}

struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let maxLength = max(width, height)
    static let minLength = min(width, height)
    static let navBarHeight = EFUtil.convertSizeByDensity(size: 44)
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            return topPadding ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    static let statusBarNavBarHeight = statusBarHeight + navBarHeight
    static let searchBarHeight = EFUtil.convertSizeByDensity(size: 48)
}

struct APIParams {
    static let apiKey = "api_key"
    static let method = "method"
    static let tags = "tags"
    static let format = "format"
    static let noJsonCallback = "nojsoncallback"
    static let extras = "extras"
    static let perPage = "per_page"
    static let page = "page"
}

struct APIValueForParams {
    static let format = "json"
    static let noJsonCallback = "1"
    static let extrasMedia = "media"
    static let extrasUrlSq = "url_sq"
    static let extrasUrlM = "url_m"
    static let perPage = "20"
}

struct Electrolux {
    struct apiCredential {
        static let baseURL: String = "https://api.flickr.com/"
        static let apiKey: String = "deefa777fd990acfd1d26232eb827f58"
        static let method: String = "flickr.photos.search"
    }
}
