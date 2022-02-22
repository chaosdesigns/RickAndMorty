//
//  CharacterRec.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-22.
//

import Foundation
import UIKit

//__________________________________________________________________________
struct CharacterRec: Identifiable {
	var id: String = ""
	var name: String = ""
	var status: String = ""
	var species: String = ""
	var gender: String = ""
	var location: String = ""
	var episodes: Int = 0
	var avatar_url: String = ""
	var avatar: UIImage? = nil
	var created: Date? = nil

}

// structs for mapping incomming json
//__________________________________________________________________________
struct CharacterJson: Decodable, Identifiable {
	var id: Int
	var name: String
	var status: String
	var species: String
	var type: String
	var gender: String
	var image: String
	var url: String
	var origin: LocationInfoJson
	var location: LocationInfoJson
	var episode: [String]
	var created: String		// timestamp
}

//__________________________________________________________________________
struct LocationInfoJson: Decodable {
	var name: Int
	var url: Int
}

//__________________________________________________________________________
struct PageInfoJson: Decodable {
	var count: Int
	var pages: Int
	var next: String
	var prev: String
}

//__________________________________________________________________________
struct CharacterPageJson: Decodable {
	var info: PageInfoJson
	var results: [CharacterJson]
}


//__________________________________________________________________________
// create some sample data to play wth
let testCharacters = [
	CharacterRec(id: "1", name: "Rick Sanchez", status: "Alive", species: "Human", gender: "Male", location: "Citadel of Ricks", episodes: 51, avatar_url: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
	CharacterRec(id: "2", name: "Morty Smith", status: "Alive", species: "Human", gender: "Male", location: "Citadel of Ricks", episodes: 51, avatar_url: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"),
	CharacterRec(id: "3", name: "Summer Smith", status: "Alive", species: "Human", gender: "Female", location: "Earth (Replacement Dimension)", episodes: 51, avatar_url: "https://rickandmortyapi.com/api/character/avatar/3.jpeg"),
	CharacterRec(id: "4", name: "Beth Smith", status: "Alive", species: "Human", gender: "Female", location: "Earth (Replacement Dimension)", episodes: 51, avatar_url: "https://rickandmortyapi.com/api/character/avatar/4.jpeg"),
	CharacterRec(id: "5", name: "Jerry Smith", status: "Alive", species: "Human", gender: "Male", location: "Earth (Replacement Dimension)", episodes: 51, avatar_url: "https://rickandmortyapi.com/api/character/avatar/5.jpeg"),
	CharacterRec(id: "6", name: "Abadango Cluster Princess", status: "unknown", species: "Human", gender: "Female", location: "Abadango", episodes: 1, avatar_url: "https://rickandmortyapi.com/api/character/avatar/6.jpeg"),
	CharacterRec(id: "7", name: "Abradolf Lincler", status: "unknown", species: "Alive", gender: "Male", location: "Testicle Monster Dimension", episodes: 2, avatar_url: "https://rickandmortyapi.com/api/character/avatar/7.jpeg"),
	CharacterRec(id: "8", name: "Adjudicator Rick", status: "Dead", species: "Human", gender: "Male", location: "Citadel of Ricks", episodes: 1, avatar_url: "https://rickandmortyapi.com/api/character/avatar/8.jpeg"),
	CharacterRec(id: "9", name: "Agency Director", status: "Dead", species: "Human", gender: "Male", location: "Citadel of Ricks", episodes: 1, avatar_url: "https://rickandmortyapi.com/api/character/avatar/9.jpeg"),
	CharacterRec(id: "10", name: "Alan Rails", status: "Dead", species: "Human", gender: "Male", location: "Worldender's lair", episodes: 1, avatar_url: "https://rickandmortyapi.com/api/character/avatar/10.jpeg")
]

