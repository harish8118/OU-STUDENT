//
//  confrmVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 04/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView

@available(iOS 13.0, *)
class confrmVC: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var ingo1: UILabel!
    @IBOutlet weak var backVW: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cntvBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logo.layer.cornerRadius = self.logo.frame.size.height/2
        self.logo.layer.masksToBounds = true
        
        self.backVW.layer.cornerRadius = 5.0
        self.backVW.layer.masksToBounds = true
            
        self.cntvBttn.layer.cornerRadius = 6.0
        self.cntvBttn.layer.masksToBounds = true
        
        let defaults = UserDefaults.standard
        
        self.ingo1.text = "The name registered with the hallticket number (\(defaults.value(forKey: "HallTicket") ?? 123)) is "
        self.nameLbl.text = defaults.value(forKey: "name") as? String
        
    }
    
    @IBAction func contVAct(_ sender: UIButton) {
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
          
        let defaults = UserDefaults.standard
        guard let gitUrl = URL(string: otpAPI +  "\(defaults.value(forKey: "HallTicket") ?? 123)&MobileNo=\(defaults.value(forKey: "mobile") ?? 123)") else { return }
            
        print("url:\(gitUrl)")
        URLSession.shared.dataTask(with: gitUrl) { (data, response
                        , error) in
                        
        guard let data = data else { return }
        do {
                            
            let jsonResponse = try JSONSerialization.jsonObject(with:
                 data, options: JSONSerialization.ReadingOptions.allowFragments) as! intmax_t
             print("res:\(jsonResponse)")
            
            DispatchQueue.main.sync {
                
            if jsonResponse == 1 {
                loadingView.hide()
                //SKActivityIndicator.dismiss()

                let vc:otpVC = self.storyboard?.instantiateViewController(withIdentifier: "otpVC") as! otpVC
                self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.isToolbarHidden = true
                 // handle json...
                
            }else {
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            }
                
                            
        } catch let err {
            loadingView.hide()
            //SKActivityIndicator.dismiss()
            print("Err", err)
            }
        }.resume()
        
        
    }
    
    @IBAction func backAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
