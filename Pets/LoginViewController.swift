//
//  LoginViewController.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 27/11/2017.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var loginScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginScrollView.becomeFirstResponder()
        emailField.delegate = self
        pwField.delegate = self
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == emailField)
        {
            pwField.becomeFirstResponder()
            return true
        }
            
        else if (textField == pwField)
        {
            pwField.resignFirstResponder()
            return true
        }
        
        return false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginScrollView.setContentOffset(CGPoint(x: 0, y:40), animated: true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        loginScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        
        return true
    }

    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        AppDelegate.instance().showActivityIndicator()
        
        guard emailField.text != "", pwField.text != "" else {
            
            AppDelegate.instance().dismissActivityIndicator()
            
            return
        
        }
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: pwField.text!, completion: { (user, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    
                }
                
                alertController.addAction(OKAction)
                
                AppDelegate.instance().dismissActivityIndicator()
                
                self.present(alertController, animated: true, completion:nil)
            }
            
            
            if let user = user {
                AppDelegate.instance().dismissActivityIndicator()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! UITabBarController
                vc.selectedIndex = 0
                
                self.present(vc, animated: true, completion: nil)
            }
        })
        
        
    }
    
    
    @IBAction func backBTN(_ sender: Any) {
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Welcome")
//        present(vc, animated: true, completion: nil)
//         //self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        let prompt = UIAlertController.init(title: nil, message: "Enter your email address", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        
                    }
                    
                    alertController.addAction(OKAction)
                    
                    
                    
                    self.present(alertController, animated: true, completion:nil)
                   
                    return
                }
            }
            
            let alertController = UIAlertController(title: "Email Sent Successfully!", message: "Please check your inbox at \(userInput!).", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);

    }
    

}
