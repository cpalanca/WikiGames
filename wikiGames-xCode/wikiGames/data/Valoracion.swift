//
//  Valoracion.swift
//  wikiGames
//
//  Created by dam on 06/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class Valoracion: Codable{
    var id: Int
    var idjuego: Int
    var alias: String
    var titulo: String
    var valoracion: String
    var caratula: String

    init(_ idjuego:Int, _ alias:String, _ titulo:String, _ valoracion:String, _ caratula:String){
        self.idjuego = idjuego
        self.alias = alias
        self.titulo = titulo
        self.valoracion = valoracion
        self.caratula = caratula
        self.id = 0
    }
}
