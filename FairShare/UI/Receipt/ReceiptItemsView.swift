//
//  ReceiptItemsView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/1/24.
//

import SwiftUI

//TODO: rename ReceiptTextView
struct ReceiptItemsView: View {
	@Binding var receiptTexts: [any ReceiptText]
	@Binding var isEditing: Bool

	var receiptItems: [ReceiptItem] {
		receiptTexts.compactMap { $0 as? ReceiptItem }
	}

	var body: some View {
		List {
			ForEach(receiptItems, id: \.id) { receiptItem in
				if let index = receiptTexts.firstIndex(where: { $0.id == receiptItem.id }) {
					if isEditing {
						EditableReceiptItemView(item: Binding(
							get: { receiptTexts[index] as! ReceiptItem },
							set: { receiptTexts[index] = $0 }
						))
					} else {
						HStack {
							Text(receiptItem.title)
							Spacer()
							Text(receiptItem.costAsCurrency)
						}
					}
				}
			}
		}
	}
}

#Preview {
	ReceiptItemsView(receiptTexts: .constant([
		ReceiptInformation(title: "Fruit Shop")] + ReceiptItem.dummyArrayData
	), isEditing: .constant(true))
}
