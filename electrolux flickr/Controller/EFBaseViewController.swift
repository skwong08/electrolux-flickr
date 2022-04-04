//
//  EFBaseViewController.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit
import Kingfisher

class EFBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var bottomSafeArea: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.setupSafeAreaValue()
    }
    
    // MARK: - Bottom Safe Area Height
    func setupSafeAreaValue() {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            bottomSafeArea = window.safeAreaInsets.bottom
        } else {
            let window = UIApplication.shared.keyWindow
            bottomSafeArea = window?.safeAreaInsets.bottom ?? 0
        }
    }
}

extension UIImageView {
    func setupImage(with imageUrl: String?, placeholder: UIImage? = nil) {
        let filteredUrl = imageUrl?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        if let urlString = filteredUrl, let urL = URL(string: urlString) {
            self.kf.setImage(with: urL, options: [.cacheOriginalImage])
        } else if let image = placeholder {
            self.image = image
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
