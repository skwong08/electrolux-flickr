//
//  EFResult.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(String)
}
