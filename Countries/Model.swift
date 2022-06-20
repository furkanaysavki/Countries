//
//  Model.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 9.04.2022.
//

import Foundation

struct Model: Codable {
    let data: [Datum]
       let links: [Link]
       let metadata: Metadata
       
   }

   
   struct Datum: Codable {
       let code, name, wikiDataID: String

       enum CodingKeys: String, CodingKey {
           case code, name
           case wikiDataID = "wikiDataId"
           
           
       }
   }

   
   struct Link: Codable {
       let rel, href: String
   }

  
   struct Metadata: Codable {
       let currentOffset, totalCount: Int
   
   }
 

 
