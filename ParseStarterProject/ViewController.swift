/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    func displayAlert(title:String,message:String){
        let alertController =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    var signUpMode = true
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet var isDriverSwitch: UISwitch!
    
    // button sign up action
    @IBAction func SignupOrLogin(_ sender: Any) {
        if txtUserName.text == "" || txtPassword.text == "" {
            displayAlert(title: "Error in Form", message: "UserName and Password are Required")
        } else{
            if signUpMode {
                let user = PFUser()
                user.username = txtUserName.text
                user.password = txtPassword.text
                
                user["isDriver"] = isDriverSwitch.isOn
                
                user.signUpInBackground(block: { (sucess,error)  in
                    
                    if let error = error {
                        
                        var  displayofErrorMessage = "Please try again later"
                        
                        if let parseError = (error as NSError).userInfo["error"] as? String {
                            
                            displayofErrorMessage = parseError
                            
                        }
                        self.displayAlert(title: "SignUp Failed", message: displayofErrorMessage)
                    } else {
                        print("Sign Up SuccessFul")
                    }
                })
            } else {
                PFUser.logInWithUsername(inBackground: txtUserName.text!, password: txtPassword.text!, block: { (user,error) in
                 
                    if let error = error {
                        
                        var  displayofErrorMessage = "Please try again later"
                        
                        if let parseError = (error as NSError).userInfo["error"] as? String {
                            displayofErrorMessage = parseError
                        }
                        self.displayAlert(title: "SignUp Failed", message: displayofErrorMessage)
                    } else {
                        print("Log In SuccessFul")
                    }
                    
                })
            }
        }
    }
    
    @IBOutlet var signupOrLoginButton: UIButton!
    @IBOutlet var signupSwitchButton: UIButton!
    
    // button action switch to LogIn
    @IBAction func btnswitchSignUpMode(_ sender: Any) {
        if signUpMode {
            signupOrLoginButton.setTitle("Login", for: [])
            signupSwitchButton.setTitle("Switch To Sign Up", for: [])
            signUpMode =  false
        } else {
            signupOrLoginButton.setTitle("Sign Up", for: [])
            signupSwitchButton.setTitle("Switch To Log In", for: [])
            signUpMode =  true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
