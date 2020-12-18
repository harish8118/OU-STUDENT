//
//  loginVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 04/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView
import CoreData
import Foundation


struct loginHubs: Codable {
    let SName: String?
    let MobileNo: String?
    let HTNO: String?
    let Course: String?
    
    private enum CodingKeys: String, CodingKey {
        case SName
        case MobileNo
        case HTNO
        case Course
    }
}

@available(iOS 13.0, *)
class loginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backVW: UIView!
    @IBOutlet weak var info1: UILabel!
    
    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var pinErr: UILabel!
    @IBOutlet weak var continueAct: UIButton!
    
    var app : AppDelegate!
    var loginData : loginHubs?
    var window: UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logo.layer.cornerRadius = self.logo.frame.size.width/2
        self.logo.layer.masksToBounds = true
        
        self.backVW.layer.cornerRadius = 5.0
        self.backVW.layer.masksToBounds = true
        
        self.info1.layer.cornerRadius = 6.0
        self.info1.layer.masksToBounds = true
        
        
        self.pinTF.layer.cornerRadius = 6.0
        self.pinTF.layer.masksToBounds = true
        self.pinTF.layer.borderWidth = 1.0
        self.pinTF.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
        
        self.continueAct.layer.cornerRadius = 6.0
        self.continueAct.layer.masksToBounds = true
        
        let defaults = UserDefaults.standard
        
        self.info1.text = "Dear \(defaults.value(forKey: "name") ?? "hari"), \n you are registered with (\(defaults.value(forKey: "HallTicket") ?? 123)). Please enter pin to get login "
        
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
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
            
        }

        
        return true
    }

    @IBAction func continueAct(_ sender: UIButton) {
        if self.pinTF.text?.count ?? 0<4 {
            self.pinErr.isHidden = false
            
        }else if self.pinTF.text?.count == 4 {
            self.pinErr.isHidden = true

            let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
           
            let defaults = UserDefaults.standard
   
            guard let appdlgt = UIApplication.shared.delegate as? AppDelegate else {return}
                   let mangdCntxt = appdlgt.persistentContainer.viewContext
                   
                   let fetchrq = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginDetails")
                   do{

                    let result =  try mangdCntxt.fetch(fetchrq)  as? [NSManagedObject]
                    
                    if result?.count ?? 0>0 {
                        let tmp : String = (result?[0].value(forKey: "pin") as? String)!
                        
                        if tmp == self.pinTF.text {
                            loadingView.hide()

                            defaults.setValue("1", forKey: "Status")

                            let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                            self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                            self.navigationController?.isNavigationBarHidden = false
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else{
                            loadingView.hide()
                            
                            let alert = UIAlertController(title: "Warning", message: "Please enter valid pin to get login.", preferredStyle: UIAlertController.Style.actionSheet)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    } else {
                        loadingView.hide()
                        self.login()
                    }
 
                   }catch {
                       print("failed")
                        loadingView.hide()
                    
                        let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                   }
        }
    
    }
    

    func login(){
        
        let loadingView1 = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView1.shouldTapToDismiss = false
        loadingView1.show(on: view)
        
        let defaults = UserDefaults.standard
        
        guard let gitUrl = URL(string: loginAPI  + "\(defaults.value(forKey: "HallTicket") ?? "hari")&pin=\(self.pinTF.text!)") else { return }
         print("url:\(gitUrl)")
        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in

        guard let data = data else { return }
        do {

            let decoder = JSONDecoder()
            self.loginData = try decoder.decode(loginHubs.self, from: data)

            print("gitData:\(self.loginData)")
            if  (self.loginData?.HTNO) == nil {

                loadingView1.hide()
                let alert = UIAlertController(title: "Failed", message: "Sorry! Data is not found. \n Note: Currently - UG Results are available.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }else {
    
                defaults.setValue(self.loginData?.HTNO, forKey: "HallTicket")
                defaults.setValue(self.loginData?.SName, forKey: "name")
                defaults.setValue(self.loginData?.MobileNo, forKey: "mobile")
                defaults.setValue(self.loginData?.Course, forKey: "Course")
                defaults.setValue("1", forKey: "Status")

                DispatchQueue.main.sync {
                    
                guard let appdlgt = UIApplication.shared.delegate as? AppDelegate else {return}
                let mangdCntxt = appdlgt.persistentContainer.viewContext
                
                let usrEnty1 = NSEntityDescription.entity(forEntityName: "LoginDetails", in: mangdCntxt)!

                let user1 = NSManagedObject.init(entity: usrEnty1, insertInto: mangdCntxt)
                    user1.setValue(self.pinTF.text, forKey: "pin")

                do{
                    try mangdCntxt.save()
                    loadingView1.hide()
                    
                     let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                     self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                     self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                     self.navigationController?.isNavigationBarHidden = false
                     self.navigationController?.pushViewController(vc, animated: true)
                    
                }catch let err as NSError {
                    print("error is:\(err)")
                    loadingView1.hide()
                    let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                }
            }

        } catch let err {
            DispatchQueue.main.sync {
            //SKActivityIndicator.dismiss()
                loadingView1.hide()
            print("Err", err)
            let alert = UIAlertController(title: "Failed", message: "Sorry! Data is not found. \n Note: Currently - UG Results are available.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
            }
        }.resume()
    }
    

    @objc func resign(){
        self.pinTF.resignFirstResponder()
    }
    
}
