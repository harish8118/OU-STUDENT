//
//  soonVC.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 05/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import IQAudioRecorderController
import MediaPlayer


@available(iOS 13.0, *)
class soonVC: UIViewController, LibraryPaymentStatusProtocol, AVAudioPlayerDelegate, AVAudioRecorderDelegate, IQAudioRecorderViewControllerDelegate,IQAudioCropperViewControllerDelegate {
    

    var keyboardDoneButtonView = UIToolbar()
    var msg = [Any]()
    var blnShowingFilterPopUp = false
    let IDIOM = UI_USER_INTERFACE_IDIOM()
    var bdvc: BDViewController!
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var audioFilePath: String!
    
    @IBOutlet weak var rcrdBttn: UIButton!
    @IBOutlet weak var stopBttn: UIButton!
    @IBOutlet weak var playBttn: UIButton!
    @IBOutlet weak var rampImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playBttn.isHidden = true
        stopBttn.isHidden = true
        rampImg.isHidden = true
        
        
    }
    
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        
        audioFilePath = filePath
        playBttn.isHidden = false
        stopBttn.isHidden = false
        rampImg.isHidden = false
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
         playBttn.isHidden = false
         stopBttn.isHidden = false
         rampImg.isHidden = false
        
         controller.dismiss(animated: true, completion: nil)
    }
    
    func audioCropperController(_ controller: IQAudioCropperViewController, didFinishWithAudioAtPath filePath: String) {
    
         audioFilePath = filePath
         controller.dismiss(animated: true, completion: nil)
        
    }
    
    func audioCropperControllerDidCancel(_ controller: IQAudioCropperViewController) {
         controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordAct(_ sender: UIButton) {
        let cntrlr : IQAudioRecorderViewController = IQAudioRecorderViewController.init()
        cntrlr.delegate = self
        cntrlr.maximumRecordDuration = 300
        cntrlr.barStyle = UIBarStyle.default
        self.presentAudioRecorderViewControllerAnimated(cntrlr)
        
    }
    
    @IBAction func stopAct(_ sender: UIButton) {
        rampImg.layer.removeAllAnimations()
        playBttn.isHidden = true
        stopBttn.isHidden = true
        rampImg.isHidden = true
    }
    
    @IBAction func playAct(_ sender: UIButton) {
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioFilePath))
            audioPlayer?.play()
            
        }catch{
            print("error")
        }

        let timeInterval: CFTimeInterval = 3
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = timeInterval
        rotateAnimation.repeatCount=Float.infinity
        rampImg.layer.add(rotateAnimation, forKey: nil)
   
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        rcrdBttn.isEnabled = true
        stopBttn.isEnabled = false
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    func paymentStatus(_ message: String!) {
        navigationController?.popToViewController(self, animated: true)
        print("payment s`tatus response [\(message ?? "nothing")]")
        //[self showAlert:message];
        let responseComponents = message.components(separatedBy: "|")
        if responseComponents.count >= 25 {
            let statusCode = responseComponents[14]
            showAlert(statusCode)
        } else {
            showAlert("Something went wrong")
        }
    }
    
    func onError(_ exception: NSException?) {
        if let anException = exception {
            print("Exception got in Merchant App \(anException)")
        }
    }
    
    func tryAgain() {
        print("Try again method in Merchant App")
    }
    
    func cancelTransaction() {
        print("Cancel Transaction method in Merchant App")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAlert(_ message: String) {
        if message=="0300" {
            let vc:ThankVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankVC") as! ThankVC
            self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
            
//            let alertController = UIAlertController(title: "Success", message: "Thank You For Your Payment.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
//                print("Cancel")
//                self.navigationController?.popViewController(animated: true)
//            })
//            self.present(alertController, animated: true, completion: nil)
            
        }else if message=="0399" {
           let alertController = UIAlertController(title: "Transaction Failed", message: "Invalid Authentication at Bank.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
                let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            self.present(alertController, animated: true, completion: nil)
            
        }else if message=="0002" {
           let alertController = UIAlertController(title: "Transaction Pending", message: "Universiy is waiting for Response from Bank.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
               let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
               self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
               self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
               self.navigationController?.isNavigationBarHidden = false
               self.navigationController?.pushViewController(vc, animated: true)
                
                
            })
            self.present(alertController, animated: true, completion: nil)
            
        }else if message=="0001" {
            let alertController = UIAlertController(title: "Transaction Cancelled", message: "Error at BillDesk.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
                let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            self.present(alertController, animated: true, completion: nil)
            
        }else if message=="NA" {
            let alertController = UIAlertController(title: "Transaction Cancelled", message: "Invalid Input in the Request Message.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
                let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            let alertController = UIAlertController(title: "Payment status", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
                let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.0/0.0, green: 44.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    func createJsonObject(_ serverStr: String?) -> String? {
        let mostOuter = serverStr?.components(separatedBy: "^")
        let token = mostOuter?[1]
        let outerList = mostOuter?[0].components(separatedBy: "|")
        print("token is \(token ?? "")")
        if let aList = outerList {
            print("outerList is \(aList)")
        }
        let rawData = outerList?[7].components(separatedBy: "~")
        if let aData = rawData {
            print("rawData is \(aData)")
        }
        return token
    }
    
    @IBAction func paymntAct(_ sender: UIButton) {
        let amnt = "1"
        let mailtxt = "harishkonchadaios@gmail.com"
        
        let amt_regex = "(?=.)^\\$?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+)?(\\.[0-9]{1,2})?$"
        let regex = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
        let regextest = NSPredicate(format: "SELF MATCHES %@", amt_regex)
        let emailtest = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if (amnt.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 ) {
            
            let alertController = UIAlertController(title: "Sorry", message: "Please enter valid amount address to proceed", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
            })
            self.present(alertController, animated: true, completion: nil)
            
        } else if !regextest.evaluate(with: amnt) {
            
            let alertController = UIAlertController(title: "Sorry", message: "Please enter valid amount to proceed", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
            })
            self.present(alertController, animated: true, completion: nil)
            
        } else if !emailtest.evaluate(with: mailtxt) {
            
            let alertController = UIAlertController(title: "Sorry", message: "Please ensure passing valid mailID to proceed", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
            })
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            SHKActivityIndicator.current().displayActivity("Fetching Data")
            
            // let parameters = ["amt": "1","email": "harish@gmail.com"] as [String : Any]
            
            
            //let param1 = "amt=\(amnt)&email= "
            let str1 = "\(get_msg_token_string)"
            print("url dfgf str \(str1) ")

            //let respoStr = "OSMANIAUNI|OSM8500273483|NA|1|NA|NA|NA|INR|NA|R|osmaniauni|NA|NA|F|100918862008|862|1009Exam|9492120598|NA|NA|NA|https://uat.billdesk.com/pgidsk/pgmerc/pg_dump.jsp|BA516216F1B2D070900DE1FABF011BB5A07F5E0A091EF0EC60491843775CCBFA"
                
                //            "OSMANIAUNI|OSM7382433192|NA|1.00|NA|NA|NA|INR|NA|R|osmaniauni|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|https://osmaniaerp.com/PGSM/EAF/Student/BildeskReturnURL|9E321E4538FF6E70225AA5BA4E5F8717992562F77E0EE17542C6C3A942558799"
            
            
            let respoStr = "AIRMTST|ARP1591356006202|NA|1.00|NA|NA|NA|INR|NA|R|airmtst|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|https://uat.billdesk.com/pgidsk/pgmerc/pg_dump.jsp|3462334152"
            //
            //            let token = "AIRMTST|ARP1589868589653|NA|1.00|NA|NA|NA|INR|NA|R|airmtst|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|https://uat.billdesk.com/pgidsk/pgmerc/pg_dump.jsp|1540871602|CP1005!AIRMTST!2A865D4374C6FD1D0693D4DF42460274202A977897B0ED71BEA1612E9A418326!NA!NA!NA"
            
            
            self.bdvc = BDViewController(message: respoStr, andToken: nil, andEmail: "harishkonchadaios@gmail.com", andMobile: "9819700500")
            
            self.bdvc?.delegate = self
            SHKActivityIndicator.current().displayCompleted("")
            self.bdvc?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(self.bdvc!, animated: true)
             
//                let url = URL(string: str1)! //change the url
//
//                //create the session object
//                let session = URLSession.shared
//
//                //now create the URLRequest object using the url object
//                var request = URLRequest(url: url)
//                request.httpMethod = "POST" //set http method as POST
//
//                do {
//
//                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//                } catch let error {
//                    print(error.localizedDescription)
//
//                     let alert = UIAlertController(title: "Failed", message: "Something went  again.", preferredStyle: UIAlertController.Style.actionSheet)
//                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                     self.present(alert, animated: true, completion: nil)
//                }
//
////                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////                request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//                //create dataTask using the session object to send data to the server
//                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//                    guard error == nil else {
//                        return
//                    }
//
//                    guard let data = data else {
//                        return
//                    }
//
//                   DispatchQueue.main.sync {
//
//                    do {
//                        print("res:\(data)")
//
//                        let jsonResponse = try JSONSerialization.jsonObject(with:
//                            data, options: JSONSerialization.ReadingOptions.allowFragments) as! String
//                        print("res:\(jsonResponse)")
//
//                        let res = jsonResponse.components(separatedBy: "^")
//                        print("res:\(res)")
//
//                       DispatchQueue.main.async {
//
//                        if jsonResponse.count>0 {
//
//                            self.bdvc = BDViewController(message: jsonResponse, andToken: nil, andEmail: "harishkonchadaios@gmail.com", andMobile: "9819700500")
////
//                                self.bdvc?.delegate = self
//                                SHKActivityIndicator.current().displayCompleted("")
//                                self.bdvc?.hidesBottomBarWhenPushed = true
//                                self.navigationController?.pushViewController(self.bdvc!, animated: true)
//
//                        }
//                    }
//
//                    } catch let error {
//                        print(error.localizedDescription)
//                        let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
//                            SHKActivityIndicator.current().displayCompleted("")
//                            self.navigationController?.popViewController(animated: true)
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                                 }
//                        }
//                        })
//                task.resume()


        }
    }
    
    

}
