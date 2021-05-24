//
//  PostTableViewCell.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    static let kReuseIdentifier = "PostTableViewCell"
    let kBaseURL = "http://lorempixel.com.br"

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var textPost: UILabel!
    
    static func register(inside tableView: UITableView) {
        let nib = UINib(nibName: "PostTableViewCell", bundle: Bundle(for: PostTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: kReuseIdentifier)
    }
    
    func setup(with data: String, post: Post) {
        userName.text = data
        textPost.text = post.body
        
        let width = Int(UIScreen.main.nativeBounds.size.width)
        let imageURI = "\(self.kBaseURL)/\(width)/\(width)"
        
        if userProfileImage.image == nil {
            userProfileImage.downloaded(from:imageURI)
        }
        
        if postImage.image == nil {
            postImage.downloaded(from: imageURI)
        }
       
        userProfileImage.layer.cornerRadius = userProfileImage.frame.width/2.0
    }

}
