//
//  View+Extensions.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation
import SwiftUI

extension View {
	func placeholder<Content: View>(
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		@ViewBuilder placeholder: () -> Content) -> some View {

		ZStack(alignment: alignment) {
			placeholder().opacity(shouldShow ? 1 : 0)
			self
		}
	}
}
