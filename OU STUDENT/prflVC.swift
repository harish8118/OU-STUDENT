//
//  prflVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 31/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class prflVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var prflTbl: UITableView!
    
    var infoData : NSArray?
    
    let dasArr = ["","Name ","Father Name ","Gender ","Course ","Coursse Name ","College ","Medium ","Email ID ","Mobile No ","Identification Marks ","Address "]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
               
            let dflts = UserDefaults.standard
            let clCde = dflts.value(forKey: "HallTicket")
            
            guard let gitUrl = URL(string: prflApi + "\(clCde ?? "")") else { return }
                print("url:\(gitUrl)")
                URLSession.shared.dataTask(with: gitUrl) { (data, response
                                , error) in
                
                if let err = error {
                    print("err:\(err)")
                    let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                guard let data = data else { return }
                do {
                                    
                    self.infoData = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                    print("res:\(self.infoData)")
                    
                    DispatchQueue.main.async {
                        
                        if self.infoData?.count ?? 0>0 {
                        loadingView.hide()
                        self.prflTbl.reloadData()
                                                        
                    }else {
                        loadingView.hide()
                        //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                        
                        let alert = UIAlertController(title: "Alert", message: "No Data Found.", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                        
                    }
                                    
                } catch let err {
                    print(err.localizedDescription)
                        loadingView.hide()
                    //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                                            
                    let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    }
                }.resume()
                
            }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.infoData?.count ?? 0>0 {
            
                return 12
            }
            return 0
        }

        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cl : UITableViewCell = UITableViewCell()
            let dict = infoData?[0] as! NSDictionary
            
            
            if indexPath.row==0 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prflImg", for: indexPath) as! linkCell
                
                let url = URL(string: dict.value(forKey: "PHOTO") as! String)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

                rtrn.prflImg.image = UIImage(data: data!)

                rtrn.prflImg.layer.cornerRadius = 10.0
                rtrn.prflImg.layer.masksToBounds = true
                
                cl = rtrn
            }else if indexPath.row == 1 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "SNAME") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 2 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "FNAME") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else  if indexPath.row == 3 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "SGENDER") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 4 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "COURSE") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 5 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "COURSENAME") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 6 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "COLLNAME") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else  if indexPath.row == 7 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "MEDIUM") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 8 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "EmailId") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 9 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "SCPhone") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 10 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": 1. \(dict.value(forKey: "IDENTIFICATION1") ?? "") \n 2.\(dict.value(forKey: "IDENTIFICATION2") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }else if indexPath.row == 11 {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "prfl", for: indexPath) as! linkCell
                
                rtrn.subTtle.text = ": \(dict.value(forKey: "SCAddress1") ?? "")"
                rtrn.title.text = "\(dasArr[indexPath.row])"
                
                cl = rtrn
                
            }
            
            
            return cl
        }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 131
//        }
//    }
    
    

}
