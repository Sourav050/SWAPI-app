//
//  APICallerProtocol.swift
//  FinalApp
//
//  Created by Sourav Choubey on 08/02/24.
//

import Foundation

// Protocol defining methods for making API calls related to fetching people and person details
protocol APICallerProtocol {
    // Method to fetch a list of people (characters) from the API
    func fetchPeople(page: Int, completion: @escaping (Result<[Person], Error>) -> Void)
}
