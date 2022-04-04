//
//  EFImageListViewController.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class EFImageListViewController: EFBaseViewController {
    
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
    var editSaveBtn: UIButton!
    var editCancelBtn: UIButton!

    var photoArray: [EFPhoto]! = []
    var selectedImageArray: [EFPhoto]! = []
    var page: Int! = 1
    var isEditMode: Bool! = false
    var isPaginationFinish: Bool! = false

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
        let expectedSaveBtnSize = EFUtil.getLabelSize(text: "Save ", maximumLabelSize: maximumLabelSize, attributes: [.font: UIFont.systemFont(ofSize: EFUtil.convertSizeByDensity(size: 16))])
        
        let expectedCancelBtnSize = EFUtil.getLabelSize(text: "Cancel", maximumLabelSize: maximumLabelSize, attributes: [.font: UIFont.systemFont(ofSize: 16)])
        
        editCancelBtn = UIButton.init()
        editCancelBtn.backgroundColor = .clear
        editCancelBtn.setTitle("Cancel", for: .normal)
        editCancelBtn.setTitleColor(.electrolux_blue_337EF6, for: .normal)
        editCancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        editCancelBtn.alpha = 0
        editCancelBtn.addTarget(self, action: #selector(editCancelBtnTapped), for: .touchUpInside)
        editCancelBtn.frame = CGRect(x: ConstantSize.paddingStandard, y: 0, width: expectedCancelBtnSize.width, height: ScreenSize.navBarHeight)
        navBar.addSubview(editCancelBtn)

        editSaveBtn = UIButton.init()
        editSaveBtn.backgroundColor = .clear
        editSaveBtn.setTitle("Edit", for: .normal)
        editSaveBtn.setTitleColor(.electrolux_blue_337EF6, for: .normal)
        editSaveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        editSaveBtn.addTarget(self, action: #selector(editSaveBtnTapped), for: .touchUpInside)
        editSaveBtn.frame = CGRect(x: ScreenSize.width - expectedSaveBtnSize.width - ConstantSize.paddingStandard, y: 0, width: expectedSaveBtnSize.width, height: ScreenSize.navBarHeight)
        navBar.addSubview(editSaveBtn)
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
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        
        self.dataSource = EFImageListDataSource(cellIdentifier: "EFImageCVC", items: photoArray, isPaginationFinish: isPaginationFinish, configureCell: { (cell, photoDetails) in

            cell.setUpImageDetails(photoDetails: photoDetails)
            if self.isEditMode {
                let index = self.selectedImageArray.firstIndex(where: { $0.id == photoDetails.id}) ?? -1
                
                if index > -1 {
                    cell.imageView?.layer.borderWidth = EFUtil.convertSizeByDensity(size: 5)
                    cell.imageView?.layer.borderColor = UIColor.electrolux_blue_337EF6.cgColor
                } else {
                    cell.imageView?.layer.borderWidth = 0
                }
            } else {
                cell.imageView?.layer.borderWidth = 0
            }
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
    
    // MARK: - Button Actions
    @objc
    func editSaveBtnTapped() {
        self.view.endEditing(true)
        editSaveBtn.setTitle("Save", for: .normal)

        if isEditMode {
            if selectedImageArray.count > 0 {
                for photoDetails in selectedImageArray {
                    let filteredUrl = EFUtil.convertUrl(url: photoDetails.urlM)
                    if let urlString = filteredUrl, let url = URL(string: urlString) {
                        EFUtil.downloadImage(from: url)
                        showAlert(title: "Saved", message: "Selected image(s) has been saved.")
                        editCancelBtnTapped()
                    }
                }
            } else {
                showAlert(title: "Opss", message: "Select up to 5 images to save into your library.")
            }
        } else {
            isEditMode = true
            editSaveBtn.isSelected = true
            UIView.animate(withDuration: CGFloat(0.25)) {
                self.editCancelBtn.alpha = 1
            }
        }
    }
    
    @objc
    func editCancelBtnTapped() {
        editSaveBtn.setTitle("Edit", for: .normal)
        isEditMode = false
        editSaveBtn.isSelected = false
        selectedImageArray = []
        UIView.animate(withDuration: CGFloat(0.25)) {
            self.editCancelBtn.alpha = 0
        }
        self.updateDataSource()
    }
        
    @objc
    func cancelBtnDidTapped() {
        self.view.endEditing(true)
        
        if let searchTextField = self.searchTextField, let searchText = searchTextField.text, searchText.count > 0 {
            searchTextField.text = ""
            self.page = 1
            self.isPaginationFinish = false
            self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.imageListViewModel.search(tags: self.getSearchText(), page: page)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        editCancelBtnTapped()
    }
}

extension EFImageListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.page = 1
        self.isPaginationFinish = false
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.imageListViewModel.search(tags: self.getSearchText(), page: page)
        self.view.endEditing(true)
        return true
    }
}

extension EFImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditMode {
            var isExist = false
            for (index, imageDetails) in selectedImageArray.enumerated() {
                if imageDetails.urlM == self.imageListViewModel.photoArray[indexPath.item].urlM {
                    isExist = true
                    selectedImageArray.remove(at: index)
                    break
                }
            }
            
            if !isExist {
                if selectedImageArray.count >= 5 {
                    showAlert(title: "Sorry", message: "You are allowed to select 5 images to save at one time.")
                    return;
                }
                
                selectedImageArray.append(self.imageListViewModel.photoArray[indexPath.item])
            }
            self.updateDataSource()
        } else {
            let viewController = EFImagePreviewViewController.init()
            viewController.modalPresentationStyle = .fullScreen
            viewController.imageArray = self.imageListViewModel.photoArray
            viewController.currentPage = indexPath.item
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isPaginationFinish && indexPath.item == self.imageListViewModel.photoArray.count - 1 {
            self.imageListViewModel.search(tags: self.getSearchText(), page: page)
        }
    }
}
