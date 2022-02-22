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
		HStack {
			Spacer()
			VStack {

				IconView(image: character.avatar ?? UIImage(systemName: "person.circle")!, size: 280.0)

				Text("\(character.name)")
					.font(.body)
					.fontWeight(.bold)
					.padding(.horizontal)
					.padding(.bottom)

				Text(character.status)
					.font(.body)
					.padding(.horizontal)

				Text(character.species)
					.font(.body)
					.padding(.horizontal)

				Text(character.gender)
					.font(.body)
					.padding(.horizontal)

				Text(character.location)
					.font(.body)
					.padding(.horizontal)

				Spacer()
			}
			Spacer()
		}
		.navigationTitle("Profile")
	}
}

//_________________________________________________________
struct CharacterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterProfileView(character: testCharacters[0])
    }
}
