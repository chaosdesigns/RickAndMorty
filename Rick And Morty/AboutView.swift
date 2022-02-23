//
//  AboutView.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-23.
//

import SwiftUI

// _____________________________________________________________
struct AboutView: View {
	@Environment(\.dismiss) var dismiss

	var body: some View {
		VStack {
			Spacer()
			IconView(image: UIImage(named: "rick-and-morty")!, size: 300)
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
			.foregroundColor(.black)
			.padding()
			.frame(width: 150, height: 50)
			.background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.green]), startPoint: .top, endPoint: .bottom))
			.cornerRadius(15.0)
	}
}

// _____________________________________________________________
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
