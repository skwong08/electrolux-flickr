//
//  ViewController.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        EFApiClient.search(tags: "Electrolux", page: "1").execute { response in
            print(response)
        } onFailure: { errorMessage in
            print(errorMessage)
        }
    }


}

