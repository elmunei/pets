//
//  SignupViewController.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 27/11/2017.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,  UITextViewDelegate  {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var comPwField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var regScrollView: UIScrollView!
    
    
    
    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        regScrollView.becomeFirstResponder()
        nameField.delegate = self
        emailField.delegate = self
        password.delegate = self
        comPwField.delegate = self
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        
        let storage = FIRStorage.storage().reference(forURL: "gs://pets-9778d.appspot.com")
        
        ref = FIRDatabase.database().reference()
        userStorage = storage.child("users")

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == nameField)
        {
            emailField.becomeFirstResponder()
            return true
        }
            
        else if (textField == emailField)
        {
            password.becomeFirstResponder()
            return true
        }
            
        else if (textField == password)
        {
            comPwField.becomeFirstResponder()
            return true
        }
        
        else if (textField == comPwField)
        {
            comPwField.resignFirstResponder()
            return true
        }
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        regScrollView.setContentOffset(CGPoint(x: 0, y:70), animated: true)
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        regScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        
        return true
    }

    


    @IBAction func selectImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            nextBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBTN(_ sender: Any) {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Welcome")
//        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func nextPressed(_ sender: Any) {
        
        AppDelegate.instance().showActivityIndicator()
        
        guard nameField.text != "", emailField.text != "", password.text != "", comPwField.text != "" else { return}
        
        if password.text == comPwField.text {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: password.text!, completion: { (user, error) in
                
                
                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        
                    }
                    
                    alertController.addAction(OKAction)
                    
                    AppDelegate.instance().dismissActivityIndicator()
                    
                    self.present(alertController, animated: true, completion:nil)
                    
                    
                }
                
                if let user = user {
                    
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.nameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let metadata = FIRStorageMetadata()
                    
                    metadata.contentType = "image/jpeg"
                    
                    let uploadTask = imageRef.put(data!, metadata: metadata, completion: { (metadata, err) in
                        if err != nil {
                            
                            let alertController = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                                
                            }
                            
                            alertController.addAction(OKAction)
                            
                            AppDelegate.instance().dismissActivityIndicator()
                            
                            self.present(alertController, animated: true, completion:nil)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                
                                let alertController = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                                
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                                    
                                }
                                
                                alertController.addAction(OKAction)
                                
                                AppDelegate.instance().dismissActivityIndicator()
                                
                                self.present(alertController, animated: true, completion:nil)
                            }
                            
                            
                            if let url = url {
                                
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name" : self.nameField.text!,
                                                                "urlToImage" : url.absoluteString]
                                
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                AppDelegate.instance().dismissActivityIndicator()
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! UITabBarController
                                vc.selectedIndex = 0
                                
                             
                                
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                            
                        })
                        
                    })
                    
                    uploadTask.resume()
                    
                }
                
                
            })
            
            
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                
            }
            
            alertController.addAction(OKAction)
            
            AppDelegate.instance().dismissActivityIndicator()
            self.present(alertController, animated: true, completion:nil)
        }
        
        
        
        
        
        
        
        
        
    }

}
