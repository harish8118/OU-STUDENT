//
//  resltVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 05/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView

struct ResltHubs: Encodable,Decodable {
    let Rm: cst?
}

struct cst: Encodable,Decodable {
    let Cst_ResultDetails: [SbjctHubs]?
    let Result: String?
    let SGPA: String?
}

struct SbjctHubs: Codable {
    let Subjectcode: String?
    let SubjectName: String?
    let Grade: String?
    let Credits: String?
    
    private enum CodingKeys: String, CodingKey {
        case Subjectcode
        case SubjectName
        case Grade
        case Credits
    }
}

class resltVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var resltTblVW: UITableView!
    @IBOutlet weak var examTitle: UILabel!
    
    var resltData: [ResltHubs]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         let defaults = UserDefaults.standard
        self.examTitle.text = (defaults.value(forKey: "exam") as! String)
        
         loadingView.shouldTapToDismiss = false
         loadingView.show(on: view)
        
//         SKActivityIndicator.spinnerColor(UIColor.init(red: 239.0/255.0, green: 82.0/255.0, blue: 93.0/255.0, alpha: 1.0))
//         SKActivityIndicator.statusTextColor(UIColor.black)
//         let myFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
//         SKActivityIndicator.statusLabelFont(myFont!)
//         SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
//         SKActivityIndicator.show("Loading...", userInteractionStatus: true)
        
         
         guard let gitUrl = URL(string: resltAPI +  "\(defaults.value(forKey: "HallTicket") ?? 123)&RMID=\(defaults.value(forKey: "RMID") ?? 123)&ESID=\(defaults.value(forKey: "ESID") ?? 123)") else { return }
          print("url:\(gitUrl)")
         URLSession.shared.dataTask(with: gitUrl) { (data, response
                         , error) in
                         
         guard let data = data else { return }
         do {
                             
             let decoder = JSONDecoder()
             self.resltData = try decoder.decode([ResltHubs].self, from: data)
                         
             print("gitData:\(self.resltData)")
                             
             DispatchQueue.main.sync {
                 
             if  self.resltData == nil {
                 
                loadingView.hide()
                 //SKActivityIndicator.dismiss()
                 let alert = UIAlertController(title: "Failed", message: "Something went wrong..", preferredStyle: UIAlertController.Style.actionSheet)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 self.present(alert, animated: true, completion: nil)

                                     
             }else {
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                 self.resltTblVW.reloadData()
                 
             }
                 
             }
                             
         } catch let err {
            loadingView.hide()
             //SKActivityIndicator.dismiss()
             print("Err", err)
             }
         }.resume()
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.resltData?[0].Rm?.Cst_ResultDetails?.count ?? 0>0 {
            return (self.resltData?[0].Rm?.Cst_ResultDetails?.count ?? 0)+2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var vcl:UITableViewCell = UITableViewCell.init()
        
        if indexPath.row == 0  {
            let vl : linkCell = tableView.dequeueReusableCell(withIdentifier: "res", for: indexPath) as! linkCell
            vl.sgpa.text = "Result : \(self.resltData?[0].Rm?.Result ?? "Pass")"
            vl.res.text = "SGPA : \(self.resltData?[0].Rm?.SGPA ?? "5")"
            
            vcl = vl
        }else if indexPath.row == 1 {
            let vl:linkCell = tableView.dequeueReusableCell(withIdentifier: "sbjctHead", for: indexPath) as! linkCell
            
            vcl = vl
        }else if  indexPath.row>1  {
            let vl : linkCell = tableView.dequeueReusableCell(withIdentifier: "sbjcts", for: indexPath) as! linkCell
            
            vl.sbjctCode.text = self.resltData?[0].Rm?.Cst_ResultDetails?[indexPath.row-2].Subjectcode
            vl.sbjctName.text = self.resltData?[0].Rm?.Cst_ResultDetails?[indexPath.row-2].SubjectName
            vl.grade.text = self.resltData?[0].Rm?.Cst_ResultDetails?[indexPath.row-2].Grade
            vl.credits.text = self.resltData?[0].Rm?.Cst_ResultDetails?[indexPath.row-2].Credits
            
            vcl = vl
            
        }
        
        return vcl
    }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    if indexPath.row == 0 {
        return 40
    }else if indexPath.row == 1 {
        return 40
    }else if indexPath.row>1 {
        return 80
    }
       return 500
   }

}
