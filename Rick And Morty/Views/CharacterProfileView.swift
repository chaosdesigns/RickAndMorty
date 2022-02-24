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
			CharacterAvatarView(image: character.avatar, size: 320.0)
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
	let leadingColor = Color("AboutTextColor")
	let trailingColor = Color("AboutShadowColor")

	var body: some View {
		HStack {
			Text(title)
				.foregroundColor(.white)
				.fontWeight(.bold)

			Spacer()

			Text(value)
				.foregroundColor(.white)
		}
		.font(.body)
		.padding(8)
		.background(LinearGradient(gradient: Gradient(colors: [leadingColor, trailingColor]), startPoint: .leading, endPoint: .trailing))
		.cornerRadius(10)
		.padding(.horizontal, 32)
	}
}

//_________________________________________________________
struct CharacterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterProfileView(character: testCharacters[0])
    }
}
