//
//  notifyVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 08/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView
import Alamofire

class notifyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var notifyTbl: UITableView!
    
    var notfyData : NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
        guard let gitUrl = URL(string: notfyApi ) else { return }
                        
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
                        
                    self.notifyTbl.reloadData()
                                                    
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
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.notfyData?.count ?? 0>0 {
            return self.notfyData?.count ?? 0
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rtrn : linkCell = tableView.dequeueReusableCell(withIdentifier: "notifc", for: indexPath) as! linkCell
        
        rtrn.indxLbl.text = "\(indexPath.row+1)."
        
        let str = self.notfyData?[indexPath.row] as! NSDictionary
        let str2 = str.value(forKey: "CreatedDate") as! String
        let tmp = str2.split(separator: "T")
        rtrn.dateLbl.text = String(tmp[0])
        
        rtrn.cntntLbl.text = str.value(forKey: "NDescription") as? String
        
        rtrn.layer.cornerRadius = 8.0
        rtrn.layer.borderWidth = 1.0
        rtrn.layer.masksToBounds = true
        return rtrn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let str = self.notfyData?[indexPath.row] as! NSDictionary
        
        let vc:notfyDtls = self.storyboard?.instantiateViewController(withIdentifier: "notfyDtls") as! notfyDtls
        vc.ntfyUrl = str.value(forKey: "ImagePath") as? String
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    

}
