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
	@Published var isLoadingPage = false

	private var currentPage = 0
	private var totalPages = 0
	private var canLoadMorePages = true

	static var shared = CharacterListModel()

	//_________________________________________________________
	init() {
		characters = testCharacters
	}

}


