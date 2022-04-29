//
//  DetailsModel.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 11.04.2022.
//

import Foundation


struct DetailsModel: Codable {
    let data: DataClass
}


struct DataClass: Codable {
    let capital, code, callingCode: String
    let flagImageURI: String
    let name: String
    let numRegions: Int
    let wikiDataID: String

    enum CodingKeys: String, CodingKey {
        case capital, code, callingCode
        case flagImageURI = "flagImageUri"
        case name, numRegions
        case wikiDataID = "wikiDataId"
    }
}
