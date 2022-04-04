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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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

    // MARK: - Shared Method
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

extension UIImageView {
    func setupImage(with imageUrl: String?, placeholder: UIImage? = nil) {
        let filteredUrl = EFUtil.convertUrl(url: imageUrl)
        if let urlString = filteredUrl, let urL = URL(string: urlString) {
            self.kf.setImage(with: urL, options: [.cacheOriginalImage])
        } else if let image = placeholder {
            self.image = image
        }
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

