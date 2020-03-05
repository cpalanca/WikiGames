//
//  Juego.swift
//  wikiGames
//
//  Created by dam on 06/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import Foundation

class Juego:Codable{
    var id: Int
    var titulo: String
    var caratula: String
    var tipo: String
    var flanzamiento: String
    var descripcion: String
    var media: String?
    
    init(_ titulo:String, _ caratula:String, _ tipo:String, _ flanzamiento:String, _ descripcion:String, _ media: String?){
        self.id = 0
        self.titulo = titulo
        self.caratula = caratula
        self.tipo = tipo
        self.flanzamiento = flanzamiento
        self.descripcion = descripcion
        self.media = media!
    }
}
