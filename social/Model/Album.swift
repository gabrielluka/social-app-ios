//
//  Album.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import Foundation

// MARK: - Welcome
struct Album: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
