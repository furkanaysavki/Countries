//
//  Model.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 9.04.2022.
//

import Foundation

struct CountriesModel: Codable {
    let data: [Country]
}

struct Country: Codable {
    let code: String
    let name: String
}

 
