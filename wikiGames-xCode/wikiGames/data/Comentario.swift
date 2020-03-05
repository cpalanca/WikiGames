//
//  Comentario.swift
//  wikiGames
//
//  Created by dam on 06/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class Comentario: Codable{
    var id: Int
    var alias: String
    var titulo: String
    var caratula: String
    var comentario: String
    var fecha: String
    
    init(_ alias:String, _ titulo:String, _ caratula:String,
        _ comentario:String, _ fecha:String){
        self.alias = alias
        self.titulo = titulo
    self.caratula = caratula
    self.comentario = comentario
    self.fecha = fecha
        self.id = 0
    }
}
