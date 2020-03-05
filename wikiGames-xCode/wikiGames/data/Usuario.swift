//
//  Usuario.swift
//  wikiGames
//
//  Created by dam on 06/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import Foundation

class Usuario:Codable{
    var id: Int
    var alias: String
    var correo: String
    var password: String
    
    init(_ alias:String, _ correo:String, _ clave:String){
        self.alias = alias
        self.correo = correo
        self.password = clave
        self.id = 0
    }
}
