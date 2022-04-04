//
//  EFImagePreviewCVC.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class EFImagePreviewCVC: UICollectionViewCell {
    var imageView: UIImageView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView.init()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        self.contentView.addSubview(imageView)
    }
    
    func setUpImageGalleryDetails(photoDetails: EFPhoto) {
        let filteredUrl = EFUtil.convertUrl(url: photoDetails.urlM)
        if let urlString = filteredUrl, let urL = URL(string: urlString) {
            self.imageView.kf.setImage(with: urL, options: [.transition(.fade(1)), .cacheOriginalImage])
        }
    }
}
