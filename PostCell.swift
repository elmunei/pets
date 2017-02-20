//
//  PostCell.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 2017/02/16.
//  Copyright © 2017 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UICollectionViewCell {
    
    
    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var unfollowBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var postTime: UILabel!
    
    
    var postID: String!
    
    @IBAction func likePressed(_ sender: Any) {
        
        self.likeBtn.isEnabled =  false
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String: AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike/\(keyToPost)" : FIRAuth.auth()!.currentUser!.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                    let count = likes.count
                                    self.likesLabel.text = "\(count)"
                                    
                                    let update = ["likes" : count]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeBtn.isHidden = true
                                    self.unlikeBtn.isHidden = false
                                    self.likeBtn.isEnabled = true
                                }
                            
                            
                            }
                            
                        })
                    }
                    
                })
                
            }
        })
        
        ref.removeAllObservers()
    }
    
    
    
    @IBAction func unlikePressed(_ sender: Any) {
        
        self.unlikeBtn.isEnabled = false
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String: AnyObject] {
                    for (id,person) in peopleWhoLike {
                        if person as? String == FIRAuth.auth()!.currentUser!.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: {(error, reff) in
                            
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likesLabel.text = "\(count)"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes": count])
                                            } else {
                                                self.likesLabel.text = "0"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes": 0])
                                            
                                            }
                                        
                                        }
                                        
                                    })
                                
                                }
                            
                            })
                                self.likeBtn.isHidden = false
                                self.unlikeBtn.isHidden = true
                                self.unlikeBtn.isEnabled = true
                                break
                        }
                    }
                }
            }
        })
            ref.removeAllObservers() 
    }
}
