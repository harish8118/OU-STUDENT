//
//  setPinVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 04/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView
import CoreData
import Foundation


@available(iOS 13.0, *)
class setPinVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backVW: UIView!
    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var pinErr: UILabel!
    @IBOutlet weak var cnfrmPin: UITextField!
    @IBOutlet weak var cnfrmErr: UILabel!
    @IBOutlet weak var sbmtBttn: UIButton!
    
    var app : AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logo.layer.cornerRadius = self.logo.frame.size.height/2
        self.logo.layer.masksToBounds = true
        
        self.backVW.layer.cornerRadius = 5.0
        self.backVW.layer.masksToBounds = true
        
        self.pinTF.layer.cornerRadius = 6.0
        self.pinTF.layer.masksToBounds = true
        self.pinTF.layer.borderWidth = 1.0
        self.pinTF.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
        
        self.cnfrmPin.layer.cornerRadius = 6.0
        self.cnfrmPin.layer.masksToBounds = true
        self.cnfrmPin.layer.borderWidth = 1.0
        self.cnfrmPin.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
        
        self.sbmtBttn.layer.cornerRadius = 6.0
        self.sbmtBttn.layer.masksToBounds = true
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.cnfrmPin.inputAccessoryView = toolBar5
        self.pinTF.inputAccessoryView = toolBar5
        
        app = UIApplication.shared.delegate as? AppDelegate
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

         if textField==self.pinTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.pinTF.text?.count ?? 0<4) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }else if textField==self.cnfrmPin {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.cnfrmPin.text?.count ?? 0<4) || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason){
        if textField == self.pinTF {
            if self.pinTF.text?.count ?? 0>0 {
                self.pinErr.isHidden = true
            }else {
                self.pinErr.isHidden = false
            }
        }
        
        if textField == self.cnfrmPin {
            if self.pinTF.text != self.cnfrmPin.text && self.pinTF.text?.count ?? 0>0 {
                self.cnfrmErr.isHidden = false
            }
        }
    }
    
    @IBAction func submitAct(_ sender: UIButton) {
        
        if self.pinTF.text?.count ?? 0>0 && self.cnfrmPin.text?.count ?? 0>0 && self.pinTF.text == self.cnfrmPin.text {
            
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
            
            let myDevice : UIDevice = UIDevice.current
            let identifier : String = myDevice.identifierForVendor!.uuidString

            let defaults = UserDefaults.standard
            guard let gitUrl = URL(string: setPinAPI +  "\(defaults.value(forKey: "HallTicket") ?? 123)&pin=\(self.pinTF.text!)&DeviceID=\(identifier)&Mobile=\(defaults.value(forKey: "mobile") ?? "")") else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
                            
            guard let data = data else { return }
            do {
                                
                let jsonResponse = try JSONSerialization.jsonObject(with:
                     data, options: JSONSerialization.ReadingOptions.allowFragments) as! intmax_t
                 print("res:\(jsonResponse)")
                                
                DispatchQueue.main.sync {
                    
                if  jsonResponse == 1 {
                    
                    loadingView.hide()
                    defaults.setValue("1", forKey: "pinStatus")
                    defaults.setValue("0", forKey: "Status")
                     let vc:loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! loginVC
                     self.navigationController?.pushViewController(vc, animated: true)
                     self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                     self.navigationController?.isToolbarHidden = true
                       
                }else {
                    loadingView.hide()
    
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
        
        
    }
    
    @objc func resign(){
        self.cnfrmPin.resignFirstResponder()
        self.pinTF.resignFirstResponder()
    }

    @IBAction func backAct(_ sender: UIButton) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.isToolbarHidden = true
        
    }
}


//                    guard let appdlgt = UIApplication.shared.delegate as? AppDelegate else {return}
//                    let mangdCntxt = appdlgt.persistentContainer.viewContext
//
//                    let usrEnty1 = NSEntityDescription.entity(forEntityName: "LoginDetails", in: mangdCntxt)!
//
//                    let user1 = NSManagedObject.init(entity: usrEnty1, insertInto: mangdCntxt)
//                        user1.setValue(self.pinTF.text, forKey: "pin")



