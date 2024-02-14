//
//  PersonResponse.swift
//  FinalApp
//
//  Created by Sourav Choubey on 08/02/24.
//

import Foundation

struct PersonResponse : Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Person]
}
