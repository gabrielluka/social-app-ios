//
//  FollowersTableViewCell.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var follower: Follower? {
        didSet {
            if let follower = follower {
                name.text = follower.name
                userName.text = follower.username
            }
        }
    }
    
}
