//
//  SetUPViewController.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 2017/02/17.
//  Copyright © 2017 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit



class SetUPViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signUpProPic: UIImageView!

    var ref: FIRDatabaseReference!
    var imgPicker = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgPicker.delegate = self;
        
        signUpProPic.layer.cornerRadius = signUpProPic.frame.size.width / 2
        signUpProPic.clipsToBounds = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addProPic(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.modalPresentationStyle = .popover
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
    }
        
    }

    @IBAction func submitBtn(_ sender: Any) {
        AppDelegate.instance().showActivityIndicator()
        
        if nameTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Username cannot be blank", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                
            }
            
            alertController.addAction(OKAction)
            
            
            
            self.present(alertController, animated: true, completion:nil)

            print("error!")
            AppDelegate.instance().dismissActivityIndicator()

        
            return
        
        
        }
        
        
        
        if signUpProPic != nil && nameTextField.text != nil {
            
            
            
            let databaseRef = FIRDatabase.database().reference()
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            let uploadData = UIImageJPEGRepresentation(self.signUpProPic.image!, 0.4)
            
            let imageName = NSUUID().uuidString
            
            let storageRef = FIRStorage.storage().reference().child("users").child("\(imageName).jpg")
            storageRef.put(uploadData!, metadata: nil) {
                metadata, error in
                
                if error != nil {
                    
                    print("error!")
                    AppDelegate.instance().dismissActivityIndicator()
                    
                    return
                    
                }
                else {
                    
                    
                    let username = self.nameTextField.text
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let user = ["uid" as NSObject : uid! as AnyObject,
                                    "full name" as NSObject : username! as AnyObject,
                                    "provider" as NSObject : FIRFacebookAuthProviderID,
                                    "urlToImage": profileImageUrl] as [AnyHashable : Any]
                        
                        Pets.sharedInstance.signUpProPic = profileImageUrl
                        
                        let childUpdates = ["users/\(uid!)/" : user]
                        databaseRef.updateChildValues(childUpdates)
                        
                        AppDelegate.instance().dismissActivityIndicator()
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! UITabBarController
                        vc.selectedIndex = 0
                        
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                }
            } 
            
        }
        

    }
    
    func completeSign(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData )
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        signUpProPic.image = image
        self.dismiss(animated: true, completion: nil);
        
    }

    
}
