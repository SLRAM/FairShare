//
//  EditableReceiptItemView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/1/24.
//

import SwiftUI

struct EditableReceiptItemView: View {
	@Binding var item: ReceiptItem
	@State private var editedItem: String = ""
	@State private var editedCost: String = ""

	var body: some View {
		HStack {
			TextField("Enter item", text: $editedItem, onCommit: {
				item.title = editedItem
			})
			.textFieldStyle(RoundedBorderTextFieldStyle())

			TextField("Enter cost", text: $editedCost, onCommit: {
				if let newCost = Double(editedCost) {
					item.cost = newCost
				}
			})
			.textFieldStyle(RoundedBorderTextFieldStyle())
			.keyboardType(.decimalPad)
			.multilineTextAlignment(.trailing)
			.onAppear {
				editedItem = item.title
				editedCost = String(format: "%.2f", item.cost)
			}
		}
	}
}

#Preview {
	EditableReceiptItemView(item: .constant(ReceiptItem(title: "Apple", cost: 1.99)))
}
