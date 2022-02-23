//
//  CharacterListModel.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-22.
//

import Foundation
import Combine
import SwiftUI

//_________________________________________________________
class CharacterListModel: ObservableObject {
	@Published var characters = [CharacterRec]()
	@Published var characterCount = 0
	@Published var isLoadingPage = false {
		didSet {
			if isLoadingPage == false && pendingFetch == true {
				changeFetchParameters()
			}
		}
	}
	@Published var searchText = "" {
		didSet {
			changeFetchParameters()
		}
	}
	private var pendingFetch = false;

	private var currentPage = 0
	private var canLoadMorePages = true

	static var shared = CharacterListModel()

	//_________________________________________________________
	init() {
		fetchMoreCharacters()
	}

	//_________________________________________________________
	func changeFetchParameters() {

		guard !isLoadingPage else {
			self.pendingFetch = true
			return
		}
		self.pendingFetch = false
		self.characters = [CharacterRec]()
		self.characterCount = 0
		self.currentPage = 0
		self.canLoadMorePages = true
		fetchMoreCharacters()
	}

	//_________________________________________________________
	func fetchMoreCharactersIfNeeded(currentCharacter character: CharacterRec?) {
		guard let character = character else {
			// if we dont have a character, we need to load the next page
			fetchMoreCharacters()
			return
		}

		// determine if we need to load more content...(10 rows before needed)
		let thresholdIndex = characters.index(characters.endIndex, offsetBy: -10)
		if characters.firstIndex(where: { $0.id == character.id }) == thresholdIndex {
			fetchMoreCharacters()
		}
	}

	//_________________________________________________________
	private func fetchMoreCharacters() {
		guard !isLoadingPage && canLoadMorePages else {
			return	// already loading... exit
		}

		isLoadingPage = true

		// load a page of users
		loadUsingDataTaskPublisher(pageNum: self.currentPage)
	}

	//_________________________________________________________
	func loadUsingDataTaskPublisher(pageNum: Int) {
		// this is a magical function!
		var urlString = "https://rickandmortyapi.com/api/character/?page=\(pageNum+1)"	// remember... the pageNum in the URL is 1-based
		if !self.searchText.isEmpty {
			urlString += "&name=\(self.searchText)"
		}
		urlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
		urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		print("Loading page using url: [\(urlString)]")

		guard let url = URL(string: urlString) else {
			print("BAD URL when Loading page using url: [\(urlString)]")
			return
		}

		URLSession.shared.dataTaskPublisher(for: url)
			.map(\.data)											// convert the contents of this tuple to another type.
			.decode(type: CharacterPageJson.self, decoder: JSONDecoder())	// convert raw data received to our types (in this case a CharacterPageJson)
			.eraseToAnyPublisher()
			.receive(on: DispatchQueue.main)						// receive on the main thread
			.handleEvents(receiveOutput: { data in
				self.characterCount = data.info.count
				self.canLoadMorePages = data.info.next != nil
				self.isLoadingPage = false
				self.currentPage += 1
			})
			.map({ response in
				// process the user records in the response.data array
				for characterJ in response.results {	// loop through characters loaded (these are CharacterJson recs)
					var characterInfo = CharacterRec()	// create a character record
					characterInfo.setFromCharacterJson(characterJson:characterJ)
					let nextIndex = self.characters.count // get index of last member of array BEFORE adding the new character
					self.characters.append(characterInfo)	// add it to our array (in 'nextIndex' position)
					self.requestAvatarForCharacterIndex(nextIndex)	// request the avatar for it
				}
				return self.characters
			})
			.catch({ error in
				Just(self.characters)	// just once
			})
			.assign(to: &$characters)
	}

	//_________________________________________________________
	func requestAvatarForCharacterIndex(_ index: Int) {
		if index >= self.characters.count {
			return
		}

		if self.characters[index].avatar != nil {
			return
		}

		let url = URL(string: self.characters[index].avatar_url)!
		getData(from: url) { optData, response, error in
			guard let imageData = optData else {
				return
			}

			// always update the UI from the main thread
			DispatchQueue.main.async() { [weak self] in
				if self != nil && index >= self!.characters.count {
					return
				}
				//convert the return data into an image
				let uiImage: UIImage? = UIImage(data: imageData)
				self?.characters[index].avatar = uiImage
			}
		}
	}

	//_________________________________________________________
	func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}

}


