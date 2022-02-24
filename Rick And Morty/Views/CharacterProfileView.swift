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
			RoundedImageView(image: character.avatar, size: 320.0)
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
fileprivate struct InfoView: View {
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
		.padding(6)
		.background(LinearGradient(gradient: Gradient(colors: [leadingColor, trailingColor]), startPoint: .leading, endPoint: .trailing))
		.padding(.horizontal, 32)
	}
}

//_________________________________________________________
struct CharacterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterProfileView(character: testCharacters[0])
    }
}
