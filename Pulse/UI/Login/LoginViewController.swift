//
//  ViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 12/31/17.
//  Copyright © 2017 Luke Klinker. All rights reserved.
//

import UIKit
import Alamofire
import Async

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login(0)
        return true
    }
    
//    @IBAction func signup(_ sender: Any) {
//        if let url = URL(string: "https://messenger.klinkerapps.com/overview/platform-ios.html") {
//            UIApplication.shared.open(url, options: [:])
//        }
//    }
    
    @IBAction func login(_ sender: Any) {
        if email.text != nil && email.text!.count != 0 && password.text != nil && password.text!.count != 0 {
            self.login.isEnabled = false
            self.password.resignFirstResponder()
            
            let email = self.email.text!
            let password = self.password.text!
            
            login.setTitle("Verifying login...", for: .normal)
            PulseApi.accounts().login(email: email, password: password) { (response: LoginResponse) in
                self.createAccount(loginResponse: response, password: self.password.text!)
            }
        }
    }
    
    private func createAccount(loginResponse: LoginResponse, password: String) {
        PulseApi.devices().add(accountId: loginResponse.accountId, fcmToken: Messaging.messaging().fcmToken) { deviceId in
            debugPrint("writing new device id: \(deviceId)")
            Account.updateDeviceId(id: deviceId)
        }
        
        Async.main {
            do {
                debugPrint("creating account encryption.")
                try Account.createAccount(password: password, accountId: loginResponse.accountId, name: loginResponse.name, number: loginResponse.number, salt1: loginResponse.salt1, salt2: loginResponse.salt2)
            } catch {
                debugPrint("error creating encryption for account.")
            }
        }.main {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessengerNavigationController") as! MessengerNavigationController
            self.present(secondViewController, animated: true)
        }
    }
}

