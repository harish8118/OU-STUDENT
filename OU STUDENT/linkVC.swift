//
//  linkVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 05/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView
import Alamofire

struct linked: Codable {
    let Sem: String?
    let ExamTitle: String?
    let Program: String?
    let ESID: intmax_t?
    let RMID: intmax_t?
    
    private enum CodingKeys: String, CodingKey {
        case Sem
        case ExamTitle
        case Program
        case ESID
        case RMID
    }
}

struct LinkHubs: Codable {
    
    let ESID: intmax_t?
    let RMID: intmax_t?
    let Cst_ExamSession: linked?
    
//    private enum CodingKeys: String, CodingKey {
//        case ESID
//        case RMID
//    }
}

@available(iOS 12.0, *)
class linkVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var linkTbl: UITableView!
    

    var resltLink : [linked]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

            let loadingView1 = RSLoadingView(effectType: RSLoadingView.Effect.twins)
            loadingView1.shouldTapToDismiss = false
            loadingView1.show(on: view)
        
//            SKActivityIndicator.spinnerColor(UIColor.init(red: 239.0/255.0, green: 82.0/255.0, blue: 93.0/255.0, alpha: 1.0))
//            SKActivityIndicator.statusTextColor(UIColor.black)
//            let myFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
//            SKActivityIndicator.statusLabelFont(myFont!)
//            SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
//            SKActivityIndicator.show("Loading...", userInteractionStatus: true)
           
            let defaults = UserDefaults.standard
            guard let gitUrl = URL(string: linkAPI +  "\(defaults.value(forKey: "HallTicket") ?? 123)") else { return }
                   
        print("url:\(gitUrl)")
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
              
                if let err = error {
                    print("err:\(err)")
                    loadingView1.hide()
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
                self.resltLink = try decoder.decode([linked].self, from: data)
                            
                print("gitData:\(self.resltLink)")
                                
                DispatchQueue.main.sync {
                    
                if  self.resltLink == nil {
                     
                    loadingView1.hide()
                    //SKActivityIndicator.dismiss()
                    let alert = UIAlertController(title: "Failed", message: "Something went wrong..", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                                        
                }else {
                    loadingView1.hide()
                   //SKActivityIndicator.dismiss()
                    self.linkTbl.reloadData()
                    
                }
                    
                }
                                
            } catch let err {
                loadingView1.hide()
                //SKActivityIndicator.dismiss()
                print("Err", err)
                
                }
            }.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resltLink != nil {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vcl: linkCell = tableView.dequeueReusableCell(withIdentifier: "link", for: indexPath) as! linkCell
        vcl.linkLbl.text = "\(self.resltLink?[indexPath.row].Program ?? "ug") \(self.resltLink?[indexPath.row].Sem ?? "ug") SEM - \(self.resltLink?[indexPath.row].ExamTitle ?? "exam")"

        
        
        return vcl
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dflt : UserDefaults = UserDefaults.standard
        dflt.setValue("\(self.resltLink?[indexPath.row].Program ?? "ug") \(self.resltLink?[indexPath.row].Sem ?? "ug") SEM - \(self.resltLink?[indexPath.row].ExamTitle ?? "exam")", forKey: "exam")
        dflt.setValue(self.resltLink?[indexPath.row].ESID, forKey: "ESID")
        dflt.setValue(self.resltLink?[indexPath.row].RMID, forKey: "RMID")
        
        
        let vc:resltVC = self.storyboard?.instantiateViewController(withIdentifier: "resltVC") as! resltVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }

}
