//
//  File.swift
//
//  Created by Sourav Choubey on 06/02/24.
//
import Foundation

struct Person: Codable {
    
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    
}



/*
 "name": "Sly Moore",
 "height": "178",
 "mass": "48",
 "hair_color": "none",
 "skin_color": "pale",
 "eye_color": "white",
 "birth_year": "unknown",
 "gender": "female",
 "homeworld": "https://swapi.dev/api/planets/60/",
 "films": [
 "https://swapi.dev/api/films/5/",
 "https://swapi.dev/api/films/6/"
 ],
 "species": [],
 "vehicles": [],
 "starships": [],
 "created": "2014-12-20T20:18:37.619000Z",
 "edited": "2014-12-20T21:17:50.496000Z",
 "url": "https://swapi.dev/api/people/82/"
 }
 */
