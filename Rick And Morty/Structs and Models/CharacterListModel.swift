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
	@Published var characters = [CharacterRec]()	// our array of characters... extended as the list is scrolled
	@Published var characterCount = 0

	// some working variables as we page the load
	@Published var isLoadingPage = false {
		didSet {
			if isLoadingPage == false && pendingFetch == true {
				// trigger the pending fetch
				changeFetchParameters()
			}
		}
	}
	@Published var searchText = "" {
		didSet {
			// as the user changes the text, we re-trigger the search
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
	// called when the searchText changes to reload the list with
	// characters that match the user's search parameter
	func changeFetchParameters() {
		guard !isLoadingPage else {
			// remember that we want to fetch (as soon as the current one is done)
			self.pendingFetch = true
			return
		}
		self.pendingFetch = false			// we are fetching, so clear pending flag
		self.characters = [CharacterRec]()
		self.characterCount = 0
		self.currentPage = 0
		self.canLoadMorePages = true
		fetchMoreCharacters()
	}

	//_________________________________________________________
	// called when a character list cell is displayed
	// this determines if more characters need to be loaded (soon)
	func fetchMoreCharactersIfNeeded(currentCharacter character: CharacterRec?) {
		guard let character = character else {
			// if we dont have a character, we need to load the next page
			fetchMoreCharacters()
			return
		}

		// determine if we need to load more content...
		let rowsBeforeLoading = -10	// ...(10 rows before needed)
		let thresholdIndex = characters.index(characters.endIndex, offsetBy: rowsBeforeLoading)
		if characters.firstIndex(where: { $0.id == character.id }) == thresholdIndex {
			fetchMoreCharacters()
		}
	}

	//_________________________________________________________
	// begins and continues the loading of pages of characters
	private func fetchMoreCharacters() {
		guard !isLoadingPage && canLoadMorePages else {
			return	// already loading... exit
		}

		isLoadingPage = true

		// load a page of users
		loadUsingDataTaskPublisher(pageNum: self.currentPage)
	}

	//_________________________________________________________
	// called to load a page of characters and process them into the character array
	func loadUsingDataTaskPublisher(pageNum: Int) {
		var urlString = "https://rickandmortyapi.com/api/character/?page=\(pageNum+1)"	// remember... the pageNum in the URL is 1-based
		if !self.searchText.isEmpty {
			urlString += "&name=\(self.searchText)"
		}
		// cleanup the URL so we dont crash
		urlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
		urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		//print("Loading page using url: [\(urlString)]") // handy debug statement

		guard let url = URL(string: urlString) else {
			print("BAD URL when Loading page using url: [\(urlString)]")	// no need to FatalError here
			return
		}

		// this is a magical function!
		URLSession.shared.dataTaskPublisher(for: url)
			.map(\.data)													// convert the contents of this tuple to another type.
			.decode(type: CharacterPageJson.self, decoder: JSONDecoder())	// convert raw data received to our types (in this case a CharacterPageJson)
			.receive(on: DispatchQueue.main)								// receive on the main thread
			.handleEvents(receiveOutput: { data in
				self.characterCount = data.info.count
				self.canLoadMorePages = data.info.next != nil
				self.currentPage += 1
			}, receiveCompletion: {_ in
				self.isLoadingPage = false	// clear the loading flag
			})
			.map({ response in
				// process the user records in the response.data array
				for characterJ in response.results {						// loop through characters loaded (these are CharacterJson recs)
					var characterInfo = CharacterRec()						// create a character record
					characterInfo.setFromCharacterJson(characterJson:characterJ)
					let nextIndex = self.characters.count 					// get index of last member of array BEFORE adding the new character
					self.characters.append(characterInfo)					// add it to our array (in 'nextIndex' position)
					self.requestAvatarForCharacterIndex(nextIndex)			// request the avatar for it
				}
				return self.characters
			})
			.catch({ error in
				Just(self.characters)	// just the characters
			})
			.assign(to: &$characters)
	}

	//_________________________________________________________
	// called after a character record is created...to load their avatar
	func requestAvatarForCharacterIndex(_ index: Int) {
		if index >= self.characters.count {
			return // make sure any late requests are within our bounds
		}

		if self.characters[index].avatar != nil {
			return	// no need to re-assign... triggering a list update (with potentially an incorrect image)
		}

		guard let url = URL(string: self.characters[index].avatar_url) else {
			return // guard against a bad url in the data... dont want to crash the app
		}
		getData(from: url) { optData, response, error in
			guard let imageData = optData else {
				return
			}

			// always update the UI from the main thread
			DispatchQueue.main.async() { [weak self] in
				if self != nil && index >= self!.characters.count {
					return
				}
				// convert the return data into an image
				let uiImage: UIImage? = UIImage(data: imageData)
				self?.characters[index].avatar = uiImage
			}
		}
	}

	//_________________________________________________________
	// called from func above (separated out for readability)
	private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}

}


