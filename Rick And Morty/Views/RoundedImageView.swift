//
//  RoundedImageView.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-24.
//

import SwiftUI

// a commonly used image view
//_________________________________________________________
struct RoundedImageView : View {
	var image: UIImage?
	var size: CGFloat

	var body: some View {
		return Image(uiImage: image ?? UIImage(systemName: "person.circle")!)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(width: size, height: size)
			.cornerRadius(16)
	}
}
