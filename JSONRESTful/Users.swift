//
//  Users.swift
//  JSONRESTful
//
//  Created by Diego Bejarano on 6/11/24.
//

import Foundation
struct Users:Decodable {
    let id:Int
    let nombre:String
    let clave:String
    let email:String
}
