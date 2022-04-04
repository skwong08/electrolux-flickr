//
//  EFImageListDataSource.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class EFImageListDataSource<CELL : UICollectionViewCell, T>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    private var cellIdentifier: String!
    private var items: [T]!
    private var isPaginationFinish: Bool!

    var configureCell: (CELL, T) -> () = {_,_ in }
    
    init(cellIdentifier: String, items: [T], isPaginationFinish: Bool, configureCell: @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.isPaginationFinish = isPaginationFinish
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isPaginationFinish {
            return items.count + 1
        }

        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CELL
        else {
            fatalError("DequeueReusableCell failed while casting")
        }
        
        if indexPath.item < items.count {
            let item = self.items[indexPath.item]
            self.configureCell(cell, item)
        }

        return cell
    }
}
