//
//  ReceiptCardView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/9/24.
//

import SwiftUI

struct ReceiptCardView: View {
	var receipt: ReceiptModel

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("Date:")
					.font(.headline)
				Spacer()
				Text(receipt.date, style: .date)
					.font(.subheadline)
			}
			HStack {
				Text("Created by:")
					.font(.headline)
				Spacer()
				Text(receipt.creatorID)
					.font(.subheadline)
					.lineLimit(1)
			}
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(8)
		.shadow(radius: 2)
		.padding(.horizontal)
		.padding(.vertical, 4)
	}
}

#Preview {
	ReceiptCardView(receipt: ReceiptModel(id: UUID(), creatorID: UUID().uuidString, date: Date()))
}
