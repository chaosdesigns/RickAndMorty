//
//  CharacterListView.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-22.
//

import SwiftUI

// _____________________________________________________________
struct CharacterListView: View {
	@StateObject private var model = CharacterListModel.shared // we just need one
	@State private var showingAbout = false

	var body: some View {

		NavigationView {
			VStack {
				if model.characters.count > 0 {
					List {
						ForEach(model.characters) { character in
							CharacterListCell(character: character)
								.onAppear() {
									// when the cell appears, fetch more characters from internet, if needed
									model.fetchMoreCharactersIfNeeded(currentCharacter: character)
								}
						}
					}
					.listStyle(PlainListStyle())	// and  GroupedListStyle and InsetListStyle  pushes the left and right boundaries out!
					.listItemTint(Color.clear)

					CharacterListFooter(total: model.characterCount, loaded: model.characters.count)
				} else {
					Spacer()

					if model.isLoadingPage {
						// still loading... show activity sparks
						ProgressView()
							.scaleEffect(3)
					} else {
						// tell user no records were found
						Text("There are no characters matching your search.")
							.font(.largeTitle)
							.fontWeight(.light)
							.foregroundColor(.secondary)
							.multilineTextAlignment(.center)
							.padding(.horizontal, 30)
					}

					Spacer()
				}
			}
			.searchable(text: $model.searchText, prompt: "Find character...")	// use built in search bar
			.navigationTitle("Characters")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("About") {
						showingAbout.toggle()
					}
				}
			}
		}
		.sheet(isPresented: $showingAbout) {
			AboutView()
		}
	}
}

// _____________________________________________________________
// this was added to help debugging, but I'm gonna keep it because the user might find it useful
fileprivate struct CharacterListFooter: View {
	var total: Int
	var loaded: Int

	var body: some View {
		Text("\(total) Characters (\(loaded) Loaded)")
			.font(.body)
			.foregroundColor(.secondary)
			.fontWeight(.light)
	}
}

// _____________________________________________________________
fileprivate struct CharacterListCell: View {
	var character: CharacterRec

	var body: some View {
		NavigationLink(destination: CharacterProfileView(character: character)) {
			HStack {
				CharacterAvatarView(image: character.avatar, size: 60.0)

				VStack(alignment: .leading) {
					Text("\(character.name)")
						.font(.body)
						.fontWeight(.bold)
						.padding(.horizontal)

					Text("Episodes: \(character.episodes)")
						.font(.caption)
						.foregroundColor(.secondary)
						.padding(.horizontal)
				}

				Spacer()
			}
		}
	}
}

// _____________________________________________________________
struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
