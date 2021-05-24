//
//  Post.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import Foundation

struct Post: Codable, Identifiable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
