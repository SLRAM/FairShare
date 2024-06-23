//
//  CustomToggleStyle.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/22/24.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
	var onColor: Color
	var offColor: Color
	var thumbColor: Color

	init(onColor: Color = .green, offColor: Color = Color(.systemGray5), thumbColor: Color = .white) {
		self.onColor = onColor
		self.offColor = offColor
		self.thumbColor = thumbColor
	}

	internal func makeBody(configuration: Configuration) -> some View {
		HStack {
			configuration.label

			Spacer()

			RoundedRectangle(cornerRadius: 30)
				.fill(configuration.isOn ? onColor : offColor)
				.overlay {
					Circle()
						.fill(thumbColor)
						.padding(3)
						.offset(x: configuration.isOn ? 9 : -9)
				}
				.frame(width: 50, height: 32)
				.onTapGesture {
					withAnimation(.smooth) {
						configuration.isOn.toggle()
					}
				}
		}
	}
}
