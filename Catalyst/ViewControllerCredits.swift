//
//  ViewControllerCredits.swift
//  Catalyst
//
//  Created by Utku Tarhan on 3/31/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
// Version 1.0.3
import UIKit
import SafariServices

class ViewControllerCredits: UIViewController {

override func viewDidLoad() {
super.viewDidLoad()
    
    print("Loading viewControllerCredits")
}
    
override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
    print("Memory Warning.")
    }

    
    @IBAction func visitWebsiteClicked(_ sender: Any) {
        print("button clicked")
    if let url = URL(string: "https://utkutarhan.com")
    {

      let safariVC = SFSafariViewController(url: url)
      present(safariVC, animated: true, completion: nil)

    }
        }
    }
    

