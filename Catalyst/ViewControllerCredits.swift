//
//  ViewControllerCredits.swift
//  Catalyst
//
//  Created by Utku Tarhan on 3/31/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//


import UIKit
import SafariServices

class ViewControllerCredits: UIViewController {

override func viewDidLoad() {
super.viewDidLoad()
    
    print("Loading viewControllerCredits")
}
    
//override func didRecieveMemoryWarning() {
//super.didReceiveMemoryWarning()
//    }
//
    
    @IBAction func visitWebsiteClicked(_ sender: Any) {
        print("button clicked")
    if let url = URL(string: "https://utkutarhan.com")
    {

      let safariVC = SFSafariViewController(url: url)
      present(safariVC, animated: true, completion: nil)

    }
        }
    }
    

