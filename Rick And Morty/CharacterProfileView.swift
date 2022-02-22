//
//  CharacterProfileView.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-22.
//

import SwiftUI

struct CharacterProfileView: View {
	var character: CharacterRec

	var body: some View {
        Text("Character Profile")
    }
}

struct CharacterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterProfileView(character: testCharacters[0])
    }
}
