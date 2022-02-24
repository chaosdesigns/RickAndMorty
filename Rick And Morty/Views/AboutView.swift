//
//  AboutView.swift
//  Rick And Morty
//
//  Created by Jeff Ferguson on 2022-02-23.
//

import SwiftUI

let aboutTextColor = Color(red: 23/255, green: 177/255, blue: 199/255)
let aboutShadowColor = Color(red: 39/255, green: 129/255, blue: 116/255)

// A simple modal about view
// _____________________________________________________________
struct AboutView: View {
	@Environment(\.dismiss) var dismiss

	var body: some View {
		VStack {
			ZStack {
			Image(uiImage: UIImage(named: "rick-and-morty-title")!)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 300, height: 120)

			Text("App")
				.font(.largeTitle)
				.padding(.top, 80)
				.foregroundColor(aboutTextColor)
				.shadow(color: aboutShadowColor, radius: 1)
			}
			Text("Written by Jeff Ferguson")
				.font(.body)
				.padding()
				.padding(.bottom, 20)

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
fileprivate struct CloseButtonView : View {
	var body: some View {
		Text("Close")
			.font(.headline)
			.foregroundColor(.white)
			.padding()
			.frame(width: 150, height: 50)
			.background(LinearGradient(gradient: Gradient(colors: [aboutTextColor, aboutShadowColor]), startPoint: .top, endPoint: .bottom))
			.cornerRadius(15.0)
	}
}

// _____________________________________________________________
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
