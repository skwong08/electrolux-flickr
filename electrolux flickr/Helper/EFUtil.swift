//
//  EFUtil.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit
import Foundation
import SystemConfiguration

class EFUtil: NSObject {
    
    //MARK: - Check internet connectivity
    class func isConnectedToInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
    //MARK: - Add parameter(s) for GET url
    class func addQueryParams(url: URL, parameters: [String: String]) -> URLComponents? {
        var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
        guard urlComponents != nil else { return nil }
        
        urlComponents?.setQueryItems(with: parameters)
        
        return urlComponents
    }
    
    //MARK: - Determine the device is iPad or iPhone
    class func isIpad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
    
    //MARK: - Convert size according to the screen size
    class func convertSizeByDensity(size: CGFloat) -> CGFloat {
        if isIpad() {
            ///The value is getting for HMI overall screen size for iPad
            return size * ScreenSize.minLength / 834.0
        }
        
        ///The value is getting for HMI overall screen size for iPhone
        return size * ScreenSize.minLength / 414.0
    }
    
    //MARK: - Get Label Height according to its text with font
    class func getLabelSize (text: String, maximumLabelSize: CGSize, attributes: [NSAttributedString.Key : Any]?) -> CGSize {
        let expectLabelSize = text.boundingRect(with: maximumLabelSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        return expectLabelSize
    }
}

extension URLComponents {
    //MARK: - Set query items in to dict
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

