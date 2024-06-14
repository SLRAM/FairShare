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
				Strings.ReceiptCardView.dateTitle.text
					.font(.headline)
				Spacer()
				Text(receipt.date, style: .date)
					.font(.subheadline)
			}

			HStack {
				Strings.ReceiptCardView.creatorTitle.text
					.font(.headline)
				Spacer()
				Text(receipt.creator.abbreviatedName)
					.font(.subheadline)
					.lineLimit(1)
			}
		}
		.padding(.all, 10)
		.background(Color(.systemGray6))
		.cornerRadius(8)
		.shadow(radius: 2)
	}
}

#Preview {
	ReceiptCardView(receipt: ReceiptModel.dummyData)
}
