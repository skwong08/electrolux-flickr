//
//  EFImageListViewModel.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class EFImageListViewModel: NSObject {
    
    private var imageListVC: EFImageListViewController!
    var photoArray: [EFPhoto] = []

    convenience init(imageListVC: EFImageListViewController) {
        self.init()
        self.imageListVC = imageListVC
    }
    
    // MARK: - Search API
    func search(tags: String, page: Int) {
        let pageInString = String(format: "%d", page)
        EFApiClient.search(tags: tags, page: pageInString).execute { response in
            
            if page == 1 {
                self.photoArray = response.photos?.photo ?? []
            } else {
                self.photoArray.append(contentsOf: response.photos?.photo ?? [])
            }
            
            if response.photos?.photo?.count == 20 {
                self.imageListVC.page += 1
            } else {
                self.imageListVC.isPaginationFinish = true
            }

            self.imageListVC.updateDataSource()
        } onFailure: { errorMessage in
            self.imageListVC.updateDataSource()
        }
    }
}
