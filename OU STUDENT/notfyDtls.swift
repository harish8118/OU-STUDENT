//
//  notfyDtls.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 10/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import WebKit

class notfyDtls: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var ntfyWebVW: WKWebView!
    var ntfyUrl : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url2 = URL(string: self.ntfyUrl ?? "")
        
        ntfyWebVW.load(URLRequest(url:url2!))
        
        // Do any additional setup after loading the view.
    }

}
