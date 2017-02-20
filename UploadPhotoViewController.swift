//
//  UploadPhotoViewController.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 2017/02/15.
//  Copyright © 2017 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase

class UploadPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {
    
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postScrollView: UIScrollView!
    @IBOutlet weak var postDesc: UITextView!
    @IBOutlet weak var postLocation: UITextView!
    
    var picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

       picker.delegate = self
       postButton.isHidden = true
        
        postScrollView.becomeFirstResponder()
        textView.delegate = self
        textView.delegate = self
        textView.text = "Add Description"
        textView.textColor = UIColor.lightGray
    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == textView)
        {
            textView.becomeFirstResponder()
            return true
        }
            
        else if (textField == textView)
        {
            textView.resignFirstResponder()
            return true
        }
        
        return false
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        postScrollView.setContentOffset(CGPoint(x: 0, y:30), animated: true)
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        postScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        if textView.text.isEmpty {
            textView.text = "Add Description"
            textView.textColor = UIColor.lightGray
        }
        
        if postLocation.text.isEmpty {
            postLocation.text = "Add Location"
            postLocation.textColor = UIColor.lightGray
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            selectButton.isHidden = true
            postButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
   
    @IBAction func postPressed(_ sender: Any) {
        
        AppDelegate.instance().showActivityIndicator()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://pets-9778d.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
                let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let metadata = FIRStorageMetadata()
        
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.put(data!,metadata: metadata) {(metadata, error) in
        
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
            
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID": uid,
                                "pathToImage": url.absoluteString,
                                "likes": 0,
                                "postDesc" : self.textView.text!,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                //"authorPhoto" : pic as? String!,
                                "postID" : key] as [String: Any]
                    
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    
                    AppDelegate.instance().dismissActivityIndicator()
                    
                    self.dismiss(animated: true, completion: nil)
                
                }
            
            
            
            })
        
        }
        
        uploadTask.resume()
        
    }

    

}
