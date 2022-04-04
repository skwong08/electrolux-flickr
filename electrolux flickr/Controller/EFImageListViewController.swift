//
//  EFImageListViewController.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class EFImageListViewController: UIViewController {
    
    // MARK: - Constant for Item Cell
    struct ViewConstant {
        static let searchBarHeight = ScreenSize.searchBarHeight
        static let searchTextFieldCornerRadius = ConstantSize.paddingStandardHalf
        static let imageSizeWidth = (ScreenSize.width - ConstantSize.paddingStandard * 4) / 3
    }
    
    private var imageListViewModel: EFImageListViewModel!
    private var dataSource: EFImageListDataSource<EFImageCVC, EFPhoto>!
    
    var collectionView: UICollectionView!
    var searchTextField: UITextField!
    var cancelBtn: UIButton!
    var saveBtn: UIButton!

    var photoArray: [EFPhoto]! = []
    var page: Int! = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .electrolux_white_FFFFFF
        self.setupNavBarLayout()
        self.setupSearchBarLayout()
        self.setupCollectionView()
        self.setupViewModelForUIUpdate()
    }
    
    // MARK: - Setup Navigation Bar
    func setupNavBarLayout() {
        let navBar = UIView.init()
        navBar.backgroundColor = .electrolux_white_FFFFFF
        navBar.frame = CGRect(x: 0, y: ScreenSize.statusBarHeight, width: ScreenSize.width, height: ScreenSize.navBarHeight)
        self.view.addSubview(navBar)

        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 24))
        titleLabel.textColor = .electrolux_black_000000
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Flickr Photos"
        titleLabel.frame = CGRect(x: ConstantSize.paddingStandard, y: ScreenSize.navBarHeight / 2 - UIFont.systemFont(ofSize: 20).lineHeight / 2, width: ScreenSize.width - ConstantSize.paddingStandardDouble, height: UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 24)).lineHeight)
        navBar.addSubview(titleLabel)
        
        let maximumLabelSize = CGSize(width: ScreenSize.width, height: .greatestFiniteMagnitude)
        let expectedSaveBtnSize = EFUtil.getLabelSize(text: "Save", maximumLabelSize: maximumLabelSize, attributes: [.font: UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 16))])
        
        saveBtn = UIButton.init()
        saveBtn.backgroundColor = .clear
        saveBtn.setTitle("Save", for: .selected)
        saveBtn.setTitleColor(.electrolux_blue_337EF6, for: .normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveBtn.addTarget(self, action: #selector(saveBtnDidTapped), for: .touchUpInside)
        saveBtn.frame = CGRect(x: ScreenSize.width - expectedSaveBtnSize.width - ConstantSize.paddingStandard, y: 0, width: expectedSaveBtnSize.width, height: ScreenSize.navBarHeight)
        navBar.addSubview(saveBtn)
    }
    
    // MARK: - Setup Search Bar
    func setupSearchBarLayout() {
        let searchBarView = UIView.init()
        searchBarView.backgroundColor = .electrolux_gray_C9C9CE
        searchBarView.frame = CGRect(x: 0, y: ScreenSize.statusBarNavBarHeight, width: ScreenSize.width, height: ViewConstant.searchBarHeight)
        self.view.addSubview(searchBarView)
        
        let maximumLabelSize = CGSize(width: ScreenSize.width, height: .greatestFiniteMagnitude)
        let expectedCancelBtnSize = EFUtil.getLabelSize(text: "Cancel", maximumLabelSize: maximumLabelSize, attributes: [.font: UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 16))])
        
        cancelBtn = UIButton.init()
        cancelBtn.backgroundColor = .clear
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.electrolux_blue_337EF6, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 16))
        cancelBtn.addTarget(self, action: #selector(cancelBtnDidTapped), for: .touchUpInside)
        cancelBtn.frame = CGRect(x: ScreenSize.width - expectedCancelBtnSize.width - ConstantSize.paddingStandard, y: 0, width: expectedCancelBtnSize.width, height: ViewConstant.searchBarHeight)
        searchBarView.addSubview(cancelBtn)
        
        searchTextField = UITextField.init()
        searchTextField.backgroundColor = .electrolux_white_FFFFFF
        searchTextField.font = UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 16))
        searchTextField.textColor = .electrolux_gray_4A4B4F
        searchTextField.layer.cornerRadius = ViewConstant.searchTextFieldCornerRadius
        searchTextField.returnKeyType = .search
        searchTextField.keyboardType = .asciiCapable
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
            .font: UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 16)),
            .foregroundColor: UIColor.electrolux_gray_C9C9CE
        ])
        searchTextField.frame = CGRect(x: ConstantSize.paddingStandard, y: ConstantSize.paddingStandardHalf, width: ScreenSize.width - ConstantSize.paddingStandard * 3 - cancelBtn.frame.size.width, height: ViewConstant.searchBarHeight - ConstantSize.paddingStandard)
        searchTextField.setLeftPaddingPoints(ConstantSize.paddingStandard)
        searchBarView.addSubview(searchTextField)
    }
    
    // MARK: - Setup Collection View
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = ConstantSize.paddingStandard
        flowLayout.minimumLineSpacing = ConstantSize.paddingStandard
        flowLayout.sectionInset = UIEdgeInsets(top: ConstantSize.paddingStandard, left: ConstantSize.paddingStandard, bottom: ConstantSize.paddingStandard, right: ConstantSize.paddingStandard)
        flowLayout.itemSize = CGSize(width: ViewConstant.imageSizeWidth, height: ViewConstant.imageSizeWidth)
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(EFImageCVC.self, forCellWithReuseIdentifier: "EFImageCVC")
        collectionView.backgroundColor = .electrolux_gray_4A4B4F
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.frame = CGRect(x: 0, y: ScreenSize.statusBarNavBarHeight + ViewConstant.searchBarHeight, width: ScreenSize.width, height: ScreenSize.height - ScreenSize.statusBarNavBarHeight - ViewConstant.searchBarHeight)
        self.view.addSubview(collectionView)
    }
    
    // MARK: - View Model
    func setupViewModelForUIUpdate() {
        self.imageListViewModel = EFImageListViewModel(imageListVC: self)
        self.imageListViewModel.search(tags: self.getSearchText(), page: page)
    }
    
    func updateDataSource() {
        photoArray = self.imageListViewModel.photoArray
        
        self.dataSource = EFImageListDataSource(cellIdentifier: "EFImageCVC", items: photoArray, isPaginationFinish: false, configureCell: { (cell, photoDetails) in

            cell.setUpImageDetails(photoDetails: photoDetails)
        })
        
        DispatchQueue.main.async {
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Get Search Text
    func getSearchText() -> String {
        var defaultText = "Electrolux"
        if let searchTextField = self.searchTextField, let searchText = searchTextField.text, searchText.count > 0 {
            defaultText = searchText
        }
        
        return defaultText
    }
    
    // MARK: - Reset Search
    func resetSearch() {
        self.view.endEditing(true)
        self.page = 1
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.imageListViewModel.search(tags: self.getSearchText(), page: page)
    }
    
    // MARK: - Button Actions
    @objc
    func saveBtnDidTapped() {
        self.view.endEditing(true)
    }
    
    @objc
    func cancelBtnDidTapped() {
        searchTextField.text = ""
        resetSearch()
    }
}

extension EFImageListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        resetSearch()
        return true
    }
}


extension EFImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
