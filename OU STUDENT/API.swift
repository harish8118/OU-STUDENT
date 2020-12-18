//
//  API.swift
//  OU STUDENT
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 04/02/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import Foundation
import RSLoadingView


//let crrtIP = "http://120.138.10.249/ResultsApi/"
let crrtIP = "http://student.osmaniaerp.com/"

let loginAPI = "\(stAdrs)api/Result/Login?HTNO="

let regAPI = "\(stAdrs)api/Result/CheckLogins?HTNO="

let otpAPI = "\(stAdrs)api/Result/getOTP?HTNO="
let verfyOtpAPI = "\(stAdrs)api/Result/checkPOTP?HTNO="

let setPinAPI = "\(stAdrs)api/Result/CreatePin?HTNO="

let linkAPI = "\(stAdrs)api/Result/Getlink?HTNO="
let resltAPI = "\(stAdrs)api/Result/GetResult?HTNO="

let versionApi = "\(stAdrs)api/Result/CheckVersion?vid="

//Student Module
let ipAdrs = "http://120.138.10.249/OUCOLLEGEAPP/"

let stAdrs = "http://120.138.10.249/StudentMobile/"

let notfyApi = "\(ipAdrs)api/GetNotification"

let alrtApi = "\(stAdrs)api/Student/GetStudentMessageDetails?htNO="

let updtAlrtApi = "\(stAdrs)api/Student/GetUpdateMessageDetail?"

let alrtCuntApi = "\(stAdrs)api/Student/GetMessageCount?htno="

let prflApi = "\(stAdrs)api/Student/GetStudentDetailByHtno?htno="

let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
