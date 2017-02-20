//
//  Post.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 2017/02/16.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit

class Post: NSObject {

    var author : String!
    var authorPhoto : String!
    var likes : Int!
    var pathToImage : String!
    var userID : String!
    var postID : String!
    var postDesc: String!
    
    var peopleWhoLike: [String] = [String]()
}
