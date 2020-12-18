//
//  alertVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 29/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class alertVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var alrtTbl: UITableView!
    
    var notfyData : NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()

        
            // Do any additional setup after loading the view.
        }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
        let dflts = UserDefaults.standard
            
            guard let gitUrl = URL(string: alrtApi + "\(dflts.value(forKey: "HallTicket") ?? 123)" ) else { return }
               print("url:- \(gitUrl)")
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
                                    
                    self.notfyData = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                    print("res:\(self.notfyData)")
                    
                    DispatchQueue.main.async {
                        
                        if self.notfyData?.count ?? 0>0 {
                        loadingView.hide()
                            
                        self.alrtTbl.reloadData()
                                                        
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
            if self.notfyData?.count ?? 0>0 {
                return self.notfyData?.count ?? 0
            }
            return 0
        }

        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var sme : UITableViewCell = UITableViewCell.init()
            let str = self.notfyData?[indexPath.row] as! NSDictionary
            
            if str.value(forKey: "STATUSID") as? intmax_t == 0 {
                
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "alrt1", for: indexPath) as! linkCell
                
                rtrn.sbjctLbl.text = "\(indexPath.row+1). \(str.value(forKey: "SUBJECT") ?? "")"
 
                rtrn.msgLbl.text = str.value(forKey: "MESSAGECONTENT") as? String
                
                sme = rtrn
                
            }else {
                let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "alrt2", for: indexPath) as! linkCell
                               
                rtrn.sbjctLbl.text = "\(indexPath.row+1). \(str.value(forKey: "SUBJECT") ?? "")"
                
                rtrn.msgLbl.text = str.value(forKey: "MESSAGECONTENT") as? String
                               
                sme = rtrn
                
            }
 
            
            return sme
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let str = self.notfyData?[indexPath.row] as! NSDictionary
        print("id:\(str.value(forKey: "$id") ?? "")")
        
        let vc:alrtDtlVC = self.storyboard?.instantiateViewController(withIdentifier: "alrtDtlVC") as! alrtDtlVC
        vc.alrtData = str
        vc.rowId = "\(str.value(forKey: "$id") ?? "")"
        vc.msgID = "\(str.value(forKey: "MESSAGEID") ?? "")"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
