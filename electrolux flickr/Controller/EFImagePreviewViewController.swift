//
//  EFImagePreviewViewController.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class EFImagePreviewViewController: EFBaseViewController {
    
    struct ViewConstant {
        static let dismissBtnSize = ConstantSize.paddingStandardDouble
        static let moreBtnSize = ConstantSize.paddingSecondaryDouble
        static let maximumLabelSizeWidth = ScreenSize.width - ConstantSize.paddingSecondaryDouble * 2
    }
    
    var collectionView: UICollectionView!
    var imageArray: [EFPhoto] = []
    var currentPage: Int!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpOverallView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - Layout Setup
    func setUpOverallView() {
        self.view.backgroundColor = .electrolux_gray_273439
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = CGFloat(0)
        flowLayout.minimumLineSpacing = CGFloat(0)
        flowLayout.itemSize = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(EFImagePreviewCVC.self, forCellWithReuseIdentifier: "EFImagePreviewCVC")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.view.addSubview(collectionView)
        
        let dismissBtn = UIButton.init()
        dismissBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        dismissBtn.imageView?.contentMode = .scaleAspectFill
        dismissBtn.addTarget(self, action: #selector(dismissPreview), for: .touchUpInside)
        dismissBtn.frame = CGRect(x: ScreenSize.width - ViewConstant.dismissBtnSize - ConstantSize.paddingStandard, y: ScreenSize.statusBarHeight + ConstantSize.paddingSecondary, width: ViewConstant.dismissBtnSize, height: ViewConstant.dismissBtnSize)
        self.view.addSubview(dismissBtn)
    }
    
    // MARK: - Button Actions
    @objc
    func dismissPreview() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EFImagePreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EFImagePreviewCVC", for: indexPath) as? EFImagePreviewCVC else {
            fatalError("DequeueReusableCell failed while casting")
        }
        
        cell.setUpImageGalleryDetails(photoDetails: imageArray[indexPath.item])

        return cell
    }
}
