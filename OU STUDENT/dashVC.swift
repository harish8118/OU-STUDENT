//
//  dashVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 04/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView
import Alamofire

@available(iOS 13.0, *)
class dashVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var prflVW: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var hltckLbl: UILabel!
    @IBOutlet weak var dashTBL: UICollectionView!
    @IBOutlet weak var crseLbl: UILabel!
    
    var alrtcunt : intmax_t!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alrtcunt = 0
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.prflVW.layer.cornerRadius = self.prflVW.frame.size.height/2
        self.prflVW.layer.masksToBounds = true
        
        let defaults = UserDefaults.standard
        
        self.nameLbl.text = defaults.value(forKey: "name") as? String
        self.hltckLbl.text = defaults.value(forKey: "HallTicket") as? String
        self.crseLbl.text = defaults.value(forKey: "Course") as? String
        
//        DispatchQueue.global().async {
//            do {
//                let update = try self.isUpdateAvailable()
//                DispatchQueue.main.async {
//                    // show alert
//                    if update == true {
//                    let alert = UIAlertController(title: "Update", message: "To continue use OU Student. Please Download Update Version app.", preferredStyle: UIAlertController.Style.actionSheet)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//
//                    }
//                }
//            } catch {
//                print(error)
//            }
//        }
//
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)

        
        guard let gitUrl = URL(string: versionApi +  "4") else { return }
                                
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                                    , error) in
        
            if let err = error {
                print("err:\(err)")
                loadingView.hide()
                
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
                            
            let jsonResponse = try JSONSerialization.jsonObject(with:
                 data, options: JSONSerialization.ReadingOptions.allowFragments) as! Bool
             print("res:\(jsonResponse)")
            
            //let update = try self.isUpdateAvailable()
            
            //https://apps.apple.com/us/app/ou-student/id1498015805?ls=1
            DispatchQueue.main.sync {
                
                if  jsonResponse == false  {
                
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    let alert = UIAlertController(title: "Update", message: "Continue to use OU Student. Please Download Update Version app.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                        if let url = URL(string: "https://apps.apple.com/us/app/ou-student/id1498015805"),
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url, options: [:]) { (opened) in
                                
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                                    
                }
                loadingView.hide()
            }
                            
        } catch let err {
            loadingView.hide()
            //SKActivityIndicator.dismiss()
            print("Err", err)
            
            }
        }.resume()
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
        let defaults = UserDefaults.standard
        
        guard let gitUrl2 = URL(string: alrtCuntApi +  "\(defaults.value(forKey: "HallTicket") ?? 123)") else { return }
            
        print("url:\(gitUrl2)")
        URLSession.shared.dataTask(with: gitUrl2) { (data, response
                        , error) in
                        
        guard let data = data else { return }
        do {
                            
            let jsonResponse = try JSONSerialization.jsonObject(with:
                 data, options: JSONSerialization.ReadingOptions.allowFragments) as! intmax_t
             print("res:\(jsonResponse)")
            
            DispatchQueue.main.sync {
                
            if jsonResponse == 0 {
                loadingView.hide()
                
            }else {
                loadingView.hide()
                
                self.alrtcunt = jsonResponse
                self.dashTBL.reloadData()
            }
            }
                
                            
        } catch let err {
            loadingView.hide()
            //SKActivityIndicator.dismiss()
            print("Err", err)
            }
        }.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    		
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cl : UICollectionViewCell = UICollectionViewCell.init()
        
        if indexPath.row == 0 {
            let vcl: dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash", for: indexPath) as! dashCell
            
            vcl.layer.cornerRadius = 6.0
            vcl.layer.masksToBounds = true
            vcl.layer.borderWidth = 1.0
            vcl.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
            
            cl = vcl
            
        }else  if indexPath.row == 1 {
            let vcl: dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash1", for: indexPath) as! dashCell
            
            vcl.layer.cornerRadius = 6.0
            vcl.layer.masksToBounds = true
            vcl.layer.borderWidth = 1.0
            vcl.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
            cl = vcl
            
        }else  if indexPath.row == 2 {
            if self.alrtcunt == 0 {
                
                let vcl: dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash2", for: indexPath) as! dashCell
            
                vcl.layer.cornerRadius = 6.0
                vcl.layer.masksToBounds = true
                vcl.layer.borderWidth = 1.0
                vcl.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
                cl = vcl
                
            }else {
                let vcl: dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash5", for: indexPath) as! dashCell
                
                vcl.cuntLbl.text = "\(self.alrtcunt ?? 0)"
                vcl.cuntLbl.layer.cornerRadius = 15.0
                vcl.cuntLbl.layer.masksToBounds = true
                
                vcl.layer.cornerRadius = 6.0
                vcl.layer.masksToBounds = true
                vcl.layer.borderWidth = 1.0
                vcl.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
                    cl = vcl
                
            }
            
        }else  if indexPath.row == 3 {
            let vcl: dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash3", for: indexPath) as! dashCell
            
            vcl.layer.cornerRadius = 6.0
            vcl.layer.masksToBounds = true
            vcl.layer.borderWidth = 1.0
            vcl.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
            cl = vcl
            
        }else  if indexPath.row == 4 {
            let vcl: dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash4", for: indexPath) as! dashCell
            
            vcl.layer.cornerRadius = 6.0
            vcl.layer.masksToBounds = true
            vcl.layer.borderWidth = 1.0
            vcl.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
            cl = vcl
            
        }else if indexPath.row == 5 {
            let vcl: dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash6", for: indexPath) as! dashCell
            
            vcl.layer.cornerRadius = 6.0
            vcl.layer.masksToBounds = true
            vcl.layer.borderWidth = 1.0
            vcl.layer.borderColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
            
            cl = vcl
            
        }
        
        return cl
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row==0 {
            let vc:linkVC = self.storyboard?.instantiateViewController(withIdentifier: "linkVC") as! linkVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row==1 {
            let vc:soonVC = self.storyboard?.instantiateViewController(withIdentifier: "soonVC") as! soonVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row==2 {
            let vc:alertVC = self.storyboard?.instantiateViewController(withIdentifier: "alertVC") as! alertVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row==3 {
            let vc:notifyVC = self.storyboard?.instantiateViewController(withIdentifier: "notifyVC") as! notifyVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row==4 {
            let vc:prflVC = self.storyboard?.instantiateViewController(withIdentifier: "prflVC") as! prflVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row==5 {
            let vc:soonVC = self.storyboard?.instantiateViewController(withIdentifier: "soonVC") as! soonVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func logoutAct(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        
        guard let val: String = defaults.value(forKey: "pinStatus") as? String  else{
            let vc1:setPinVC = self.storyboard?.instantiateViewController(withIdentifier: "setPinVC") as! setPinVC
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc1, animated: true)
            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            self.navigationController?.isToolbarHidden = true
            
            return
        }
        
        if val == "1" {
            defaults.setValue("0", forKey: "Status")
            let vc:loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! loginVC
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            self.navigationController?.isToolbarHidden = true
            
        }else {
            let vc1:setPinVC = self.storyboard?.instantiateViewController(withIdentifier: "setPinVC") as! setPinVC
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc1, animated: true)
            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            self.navigationController?.isToolbarHidden = true
            
        }
        
    }
    
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
}
