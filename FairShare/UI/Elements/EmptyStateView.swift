//
//  EmptyStateView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/11/24.
//

import SwiftUI

struct EmptyStateView: View {
	let isEmpty: Bool
	let message: String

	var body: some View {
		Group {
			if isEmpty {
				Text(message)
					.multilineTextAlignment(.center)
					.padding()
			}
		}
	}
}

#Preview {
	EmptyStateView(isEmpty: true, message: "This view is empty.")
}
