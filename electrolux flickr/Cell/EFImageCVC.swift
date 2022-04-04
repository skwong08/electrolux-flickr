//
//  EFImageCVC.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class EFImageCVC: UICollectionViewCell {
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    
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
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        self.contentView.addSubview(imageView)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .clear
        activityIndicator.center = imageView.center
        activityIndicator.startAnimating()
        imageView.addSubview(activityIndicator)
    }
    
    func setUpImageDetails(photoDetails: EFPhoto) {
        activityIndicator.startAnimating()

        let filteredUrl = EFUtil.convertUrl(url: photoDetails.urlM)
        if let urlString = filteredUrl, let url = URL(string: urlString) {
            self.imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]) { result in
                self.activityIndicator.stopAnimating()
            }
        } else {
            self.imageView.image = UIImage(named: "")
            self.activityIndicator.stopAnimating()
        }
    }
}
