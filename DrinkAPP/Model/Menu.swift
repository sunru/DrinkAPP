//
//  Menu.swift
//  DrinkAPP
//
//  Created by 廖晨如 on 2022/12/31.
//

import Foundation

struct Menu: Codable {
    let records : [Records]
    
}
struct Records: Codable {
    let id: String
    let fields : Fields
}
struct Fields: Codable {
    let Name: String
    let image: [DrinkImage]
    let medium: Int
    let large: Int
    let description: String
}

struct DrinkImage: Codable{
    let url: URL
}

