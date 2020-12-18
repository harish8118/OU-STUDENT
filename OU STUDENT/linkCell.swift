//
//  linkCell.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 05/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class linkCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Results
    
    @IBOutlet weak var linkLbl: UILabel!
    
    @IBOutlet weak var sbjctCode: UILabel!
    @IBOutlet weak var sbjctName: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var credits: UILabel!
    
    
    @IBOutlet weak var sgpa: UILabel!
    @IBOutlet weak var res: UILabel!
    
    // Notification
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var sender: UILabel!
    
    
    //Notify
    
    @IBOutlet weak var cntntLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var indxLbl: UILabel!
    
    //Alerts
    
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var sbjctLbl: UILabel!
    
    //Prfl
    @IBOutlet weak var prflImg: UIImageView!
    @IBOutlet weak var subTtle: UILabel!
    @IBOutlet weak var title: UILabel!
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
