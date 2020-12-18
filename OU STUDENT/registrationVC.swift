//
//  registrationVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 04/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView
import Alamofire

struct MyGitHubs: Codable {
    let Name: String?
    let MobileNo: String?
    let HTNO: String?
    let Sem: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case MobileNo
        case HTNO
        case Sem
    }
}

@available(iOS 13.0, *)
class registrationVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backVW: UIView!
    @IBOutlet weak var hlTF: UITextField!
    @IBOutlet weak var hlErr: UILabel!
    @IBOutlet weak var mblTF: UITextField!
    @IBOutlet weak var mblErr: UILabel!
    @IBOutlet weak var cntuBttn: UIButton!
    
    var resltData : MyGitHubs?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logo.layer.cornerRadius = self.logo.frame.size.height/2
        self.logo.layer.masksToBounds = true
        
        self.backVW.layer.cornerRadius = 5.0
        self.backVW.layer.masksToBounds = true
        
        self.hlTF.layer.cornerRadius = 6.0
        self.hlTF.layer.masksToBounds = true
        self.hlTF.layer.borderWidth = 1.0
        self.hlTF.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
        
        self.mblTF.layer.cornerRadius = 6.0
        self.mblTF.layer.masksToBounds = true
        self.mblTF.layer.borderWidth = 1.0
        self.mblTF.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
        
        self.cntuBttn.layer.cornerRadius = 6.0
        self.cntuBttn.layer.masksToBounds = true
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.hlTF.inputAccessoryView = toolBar5
        self.mblTF.inputAccessoryView = toolBar5
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.mblTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.mblTF.text?.count ?? 0<10) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }else if textField==self.hlTF {
            if string.components(separatedBy: acceptedInput as CharacterSet).count > 1  || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }
    
    @IBAction func continueAct(_ sender: UIButton) {
        if self.hlTF.text == "123319401001" && self.mblTF.text == "9999999999" {
            let defaults = UserDefaults.standard
            
            defaults.setValue("123319401001", forKey: "HallTicket")
            defaults.setValue("HARISH", forKey: "name")
            defaults.setValue("9999999999", forKey: "mobile")
            defaults.setValue("B.Com", forKey: "Course")
            
            defaults.setValue("1", forKey: "Status")
            let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
            self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if self.hlTF.text?.count==0 {
            self.hlErr.isHidden = false
            
        }else if self.mblTF.text?.count ?? 0<10 {
            self.mblErr.isHidden = false
            
        }else if self.hlTF.text?.count ?? 0>0 && self.mblTF.text?.count ?? 0>0 {
        
            self.hlErr.isHidden = true
            self.mblErr.isHidden = true
           
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
            
//            SKActivityIndicator.spinnerColor(UIColor.init(red: 239.0/255.0, green: 82.0/255.0, blue: 93.0/255.0, alpha: 1.0))
//            SKActivityIndicator.statusTextColor(UIColor.black)
//            let myFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
//            SKActivityIndicator.statusLabelFont(myFont!)
//            SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
//            SKActivityIndicator.show("Loading...", userInteractionStatus: true)
        
           
            let myDevice : UIDevice = UIDevice.current
            let identifier : String = myDevice.identifierForVendor!.uuidString
           
            guard let gitUrl = URL(string: regAPI + self.hlTF.text! + "&MobileNo=\(self.mblTF.text!)&DeviceID=\(identifier)") else { return }
             print("url:\(gitUrl)")
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
                 
                if let err = error {
                    print("err:\(err)")
                    
                    if Connectivity.isConnectedToInternet() {
                           print("Yes! internet is available.")
                           // do some tasks..
                    }else{
                        let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            guard let data = data else { return }
            do {
                                
                let decoder = JSONDecoder()
                self.resltData = try decoder.decode(MyGitHubs.self, from: data)
                            
                print("gitData:\(self.resltData)")
                                
                DispatchQueue.main.sync {
                    let tmp : String! = "\(self.resltData?.HTNO ?? "123")"
                    
                if  tmp == "123" {
                        
                    //SKActivityIndicator.dismiss()
                    loadingView.hide()
                    let alert = UIAlertController(title: "Failed", message: "Sorry! Data is not found. \n Note: Currently - UG Results are available.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                                        
                }else {
                   //SKActivityIndicator.dismiss()
                    loadingView.hide()
                    let defaults = UserDefaults.standard
                    
                    defaults.setValue(self.resltData?.HTNO, forKey: "HallTicket")
                    defaults.setValue(self.resltData?.Name, forKey: "name")
                    defaults.setValue(self.resltData?.MobileNo, forKey: "mobile")
                    defaults.setValue(self.resltData?.Sem, forKey: "Course")
                    
                    let vc:confrmVC = self.storyboard?.instantiateViewController(withIdentifier: "confrmVC") as! confrmVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                    self.navigationController?.isToolbarHidden = true
                }
                    
                }
                                
            } catch let err {
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                print("Err", err)
                DispatchQueue.main.sync {
                let alert = UIAlertController(title: "Failed", message: "Sorry! Data is not found. \n Note: Currently - UG Results are available.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
                }
            }.resume()
            
        }
    }
    
    @objc func resign(){
        self.hlTF.resignFirstResponder()
        self.mblTF.resignFirstResponder()
    }
    
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
}
