//
//  SplashScreen.swift
//  Catalyst
//
//  Created by Utku Tarhan on 4/4/20.
//  Copyright © 2020 MachineThink. All rights reserved.
//
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
import Foundation
import UIKit


class SplashScreen: UIViewController {

override func viewDidLoad() {
super.viewDidLoad()
    
    print("Loading Splash Screen")
    
    setLoader()

    
}
    
    
    
override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
    }
//
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    func setLoader() {
        
        
        activity.startAnimating()
        
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { // Wait for 1 second
            
           let storyboard: UIStoryboard = UIStoryboard(name: "Main" , bundle: nil) // Full Screen Segue 
           let controller = storyboard.instantiateViewController(identifier: "Main")
           controller.modalPresentationStyle = .fullScreen
            
           self.present(controller, animated: true, completion: nil)
            
        }
        
        
       
        
        
    }
    
    
    
    
}
