//
//  WelcomeViewController.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 2017/02/17.
//  Copyright © 2017 Vasil Nunev. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()?.addStateDidChangeListener ({
            auth, user in
            
            if user != nil {
                
                print("user already signed in")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! UITabBarController
                vc.selectedIndex = 0
                
                self.present(vc, animated: true, completion: nil)
            } else {
                print("user not signed in")
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "Welcome")
                self.present(vc, animated: true, completion: nil)
            }
        })
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    @IBAction func fbButton(_ sender: Any) {
        let fbLoginButton = FBSDKLoginManager()
        
        //  fbLoginButton.readPermissions =
        fbLoginButton.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if error != nil {
                print("Elvis: Unable to authenticate with Facebook")
                
            } else if result?.isCancelled == true {
                
                print("Elvis: User cancelled Facebook authentication")
                
            }  else {
                
                print("Elvis: User successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
                
                
                
                
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "setUp")
                
                self.present(viewController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Elvis: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Elvis: User successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSign(id: user.uid, userData: userData)
                }
            }
        })
        
    }
    

    

    func completeSign(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData )
    }


}
