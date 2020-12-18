//
//  otpVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 04/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView

@available(iOS 13.0, *)
class otpVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backVW: UIView!
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var otpErr: UILabel!
    @IBOutlet weak var sbmtBttn: UIButton!
    
    var otpData : MyGitHubs?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logo.layer.cornerRadius = self.logo.frame.size.height/2
        self.logo.layer.masksToBounds = true
        
        self.backVW.layer.cornerRadius = 5.0
        self.backVW.layer.masksToBounds = true
        
        self.otpTF.layer.cornerRadius = 6.0
        self.otpTF.layer.masksToBounds = true
        self.otpTF.layer.borderWidth = 1.0
        self.otpTF.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
        
        self.sbmtBttn.layer.cornerRadius = 6.0
        self.sbmtBttn.layer.masksToBounds = true
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.otpTF.inputAccessoryView = toolBar5
        
       
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.otpTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.otpTF.text?.count ?? 0<6) || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }
    
    @IBAction func submitAct(_ sender: UIButton) {
        if self.otpTF.text?.count ?? 0>0 {
            self.otpErr.isHidden = true
            
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
            
//            SKActivityIndicator.spinnerColor(UIColor.init(red: 239.0/255.0, green: 82.0/255.0, blue: 93.0/255.0, alpha: 1.0))
//            SKActivityIndicator.statusTextColor(UIColor.black)
//            let myFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
//            SKActivityIndicator.statusLabelFont(myFont!)
//            SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
//            SKActivityIndicator.show("Loading...", userInteractionStatus: true)
                
            let defaults = UserDefaults.standard
            guard let gitUrl = URL(string: verfyOtpAPI +  "\(defaults.value(forKey: "HallTicket") ?? 123)&Otp=\(self.otpTF.text!)") else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
                            
            guard let data = data else { return }
            do {
                                
                let decoder = JSONDecoder()
                self.otpData = try decoder.decode(MyGitHubs.self, from: data)
                            
                print("gitData:\(self.otpData)")
                                
                DispatchQueue.main.sync {
                    
                if  self.otpData == nil {
                    
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    let alert = UIAlertController(title: "Failed", message: "Something went wrong..", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                                        
                }else {
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    defaults.setValue("1", forKey: "Status")
                    let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                    self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                    self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                    self.navigationController?.isNavigationBarHidden = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    
     
                }
                    
                }
                                
            } catch let err {
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                print("Err", err)
                }
            }.resume()
            
            
            
        }else {
            
            //SKActivityIndicator.dismiss()
            self.otpErr.isHidden = false
        }
        
        

    }
    
    @objc func resign(){
        self.otpTF.resignFirstResponder()
        
    }

    @IBAction func backAct(_ sender: UIButton) {
        exit(0)
    }
}
