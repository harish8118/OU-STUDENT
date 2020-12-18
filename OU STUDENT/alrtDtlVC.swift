//
//  alrtDtlVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 29/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class alrtDtlVC: UIViewController {
    
    @IBOutlet weak var sbjctLbl: UILabel!
    @IBOutlet weak var msgLbl: UITextView!
    
    var  alrtData : NSDictionary!
    var rowId : String!
    var msgID : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sbjctLbl.text = "\(alrtData.value(forKey: "SUBJECT") ?? "")"
        
        msgLbl.text = "\(alrtData.value(forKey: "MESSAGECONTENT") ?? "")"

        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
        let dflts = UserDefaults.standard
        
            
        guard let gitUrl = URL(string: updtAlrtApi + "&htno=\(dflts.value(forKey: "HallTicket") ?? 123)&msgID=\(msgID ?? "")" ) else {
            print("Error")
            return }
               print("url:- \(gitUrl)")
                URLSession.shared.dataTask(with: gitUrl) { (data, response
                                , error) in
                
                if let err = error {
                    print("err:\(err)")
                    loadingView.hide()
                    let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                guard let data = data else { return }
                do {
                                    
                    let response = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? String

                    print("res:\(response ?? "")")
                    loadingView.hide()
                    DispatchQueue.main.async {

                        loadingView.hide()

                        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
