//
//  VideoModel.swift
//  wikiGames
//
//  Created by dam on 20/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import Foundation

class VideoModel{

    func getVideos() -> [Video] {
        var videos = [Video]()
        
        // Creamos el objeto videos
        let video1 = Video()
        // Assignamos las propiedades
        video1.videoId = "2nj9Ub32ILs"
        video1.videoTitle = "Death Stranding - Tráiler de Lanzamiento en ESPAÑOL"
        video1.videoDescripcion = "Embárcate en un viaje para reconectar el mundo devastado de Death Stranding. El mañana está en tus manos. Disponible el 08/11/2019."
        // añadimos al array de videos
        videos.append(video1)
        
        // Creamos el objeto videos
        let video2 = Video()
        // Assignamos las propiedades
        video2.videoId = "g3bfjtUpKPc"
        video2.videoTitle = "The Last of Us Parte II – Primer tráiler doblado al ESPAÑOL | State of Play #3"
        video2.videoDescripcion = "Ya tenemos un nuevo trailer donde podemos oir las voces en español de los personajes de esta nueva entrega The Last of Us: Parte 2. También vemos la situación de Ellie y a lo que se tendrá que enfrentar en esta nueva aventura."
        // añadimos al array de videos
        videos.append(video2)
        
        // Creamos el objeto videos
        let video3 = Video()
        // Assignamos las propiedades
        video3.videoId = "xK3ZIs2QVo0"
        video3.videoTitle = "MARVEL'S AVENGERS - Trailer de lanzamiento en ESPAÑOL | PS4"
        video3.videoDescripcion = "Ya tenemos fecha de lanzamiento de la nueva IP de Crystal Dynamics, Marvel Avengers, saldrá el próximo 4 de septiembre de 2020. No te puedes perder a lo Vengadores en acción, Thor, Iron Man, Hulk, Capitán America, Viuda Negra y la nueva incorporación de Ms. Marvel, Kamala Khan."
        // añadimos al array de videos
        videos.append(video3)
        
        // Creamos el objeto videos
        let video4 = Video()
        // Assignamos las propiedades
        //https://i1.ytimg.com/vi/AZxK_6OQV7c/mqdefault.jpg
        video4.videoId = "tKb8rteICeM"
        video4.videoTitle = "BATTLEFIELD V - CAPÍTULO 6: En la JUNGLA | PS4"
        video4.videoDescripcion = "Cambiamos de campo de batalla en Battlefield V. En este capítulo combatiremos en la jungla con armas y mapas nuevos, además del nuevo reto multijugador. ¿Estás preparado?"
        // añadimos al array de videos
        videos.append(video4)
        
        // Creamos el objeto videos
        let video5 = Video()
        // Assignamos las propiedades
        video5.videoId = "DfhEvr4GvvY"
        video5.videoTitle = "Nioh 2 - Tráiler de la historia con subtítulos en ESPAÑOL | PS4"
        video5.videoDescripcion = "Vuelve el RPG de acción de samuráis de Team Ninja. El 13 de marzo llega Nioh 2 a PlayStation 4. Descubre cómo enfrentarte a los Yokais en el tráiler de la historia con subtítulos en castellano y reserva ya el juego. "
        // añadimos al array de videos
        videos.append(video5)
        return videos
    }
}
