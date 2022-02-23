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
				SearchBar(model: model)

				if model.characters.count > 0 {
					List {
						ForEach(model.characters) { character in
							CharacterListCell(character: character)
								.onAppear() {
									model.fetchMoreCharactersIfNeeded(currentCharacter: character)
								}
						}
					}
					.listStyle(PlainListStyle())	// and  GroupedListStyle and InsetListStyle  pushes the left and right boundaries out!
					.listItemTint(Color.clear)

					CharacterListFooter(total: model.characterCount, loaded: model.characters.count)
				} else {
					Spacer()
					if !model.isLoadingPage {
						Text("There are no characters matching your search.")
							.font(.largeTitle)
							.fontWeight(.light)
							.foregroundColor(.secondary)
							.multilineTextAlignment(.center)
							.padding(.horizontal, 30)
					} else {
						ProgressView()
							.scaleEffect(3)
					}
					Spacer()
				}
			}
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
struct SearchBar: View {
	@StateObject var model: CharacterListModel

	var body: some View {
		HStack {
			TextField("Search for a character...", text: $model.searchText)

			Button(action: {
				model.changeFetchParameters()
			}) {
				SFImage(named: "magnifyingglass.circle.fill")
					.foregroundColor(model.searchText.isEmpty ? .clear : .blue)
			}.disabled(model.searchText.isEmpty)

			Button(action: {
				model.searchText = ""
				model.changeFetchParameters()

			}) {
				SFImage(named: "xmark.circle.fill")
					.foregroundColor(model.searchText.isEmpty ? .clear : .blue)
			}.disabled(model.searchText.isEmpty)
		}
		.padding(.horizontal)
	}
}

// _____________________________________________________________
struct CharacterListFooter: View {
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
struct CharacterListCell: View {
	var character: CharacterRec

	var body: some View {
		NavigationLink(destination: CharacterProfileView(character: character)) {
			HStack {
				IconView(image: character.avatar ?? UIImage(systemName: "person.circle")!  , size: 60.0)

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
struct AboutView: View {
	@Environment(\.dismiss) var dismiss

	var body: some View {
		VStack {
			Spacer()
			Text("Rick And Morty App")
				.font(.largeTitle)
				.padding()

			Text("Written by Jeff Ferguson")
				.font(.body)
				.padding()

			Spacer()
			Button(action: handleCloseButton ) {
				CloseButtonView()
			}
			.padding()
		}
	}

	// ____________
	func handleCloseButton() {
		dismiss()
	}
}

// _____________________________________________________________
struct CloseButtonView : View {
	var body: some View {
		return Text("Close")
			.font(.headline)
			.foregroundColor(.white)
			.padding()
			.frame(width: 150, height: 50)
			.background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom))
			.cornerRadius(15.0)
	}
}

//_________________________________________________________
struct IconView : View {
	var image: UIImage
	var size: CGFloat

	var body: some View {
		return Image(uiImage: image)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(width: size, height: size)
			.cornerRadius(16)
	}
}

//_________________________________________________________
struct SFImage : View {
	var named: String

	var body: some View {
		Image(systemName: named)
			.resizable()
			.frame(width: 30, height: 30, alignment: .leading)
			.padding(.leading, 8)
	}
}

// _____________________________________________________________
struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
