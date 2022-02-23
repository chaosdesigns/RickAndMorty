//
//  CharacterProfileView.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-22.
//

import SwiftUI

//_________________________________________________________
struct CharacterProfileView: View {
	var character: CharacterRec

	var body: some View {
		VStack {
			IconView(image: character.avatar ?? UIImage(systemName: "person.circle")!, size: 280.0)
				.padding(.top, 20)

			Text("\(character.name)")
				.font(.title)
				.fontWeight(.bold)
				.padding()

			InfoView(title: "Status:", value: character.status)
			InfoView(title: "Species:", value: character.species)
			InfoView(title: "Gender:", value: character.gender)
			InfoView(title: "Location:", value: character.location)
			Spacer()
		}
		.navigationTitle("Profile")
	}
}

//_________________________________________________________
struct InfoView: View {
	var title: String
	var value: String
	let leadingColor = Color.green
	let trailingColor = Color.yellow

	var body: some View {
		HStack {
			Text(title)
				.fontWeight(.bold)

			Spacer()

			Text(value)
		}
		.font(.body)
		.padding(.horizontal, 30)
		.padding(.vertical, 10)
		.background(LinearGradient(gradient: Gradient(colors: [leadingColor, trailingColor]), startPoint: .leading, endPoint: .trailing))
	}
}

//_________________________________________________________
struct CharacterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterProfileView(character: testCharacters[0])
    }
}
