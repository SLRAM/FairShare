//
//  ReceiptItemsView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/1/24.
//

import SwiftUI

struct ReceiptItemsView: View {
	let itemsByType: [[ReceiptItem]]
	@Binding var isEditing: Bool
	@Binding var receiptTexts: [any ReceiptText]
	let itemTapped: (ReceiptItem) -> Void

	let imageToDisplay: Image?

	var body: some View {
		GeometryReader { geometry in
			List {
				ForEach(itemsByType, id: \.self) { itemInType in
					Section(header: Text(itemInType[0].type.rawValue)) {
						ForEach(itemInType) { item in
							if let index = receiptTexts.firstIndex(where: { $0.id == item.id }) {
								if isEditing {
									EditableReceiptItemView(item: Binding(
										get: { receiptTexts[index] as! ReceiptItem },
										set: { receiptTexts[index] = $0 }
									))
								} else {
									Button {
										print(item.title)
										itemTapped(item)
									} label: {
										HStack {
											Text(item.title)
											Spacer()
											Text(item.costAsCurrency)
										}
									}
								}
							}
						}
					}
				}
				if let currentImage = imageToDisplay {
					Section(header: Strings.ReceiptDetailView.imagesSectionTitle.text) {
						HStack {
							Spacer()
							currentImage
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
							ShareLink(item: currentImage, preview: SharePreview("Current Image", image: currentImage))
							Spacer()
						}
						.frame(height: geometry.size.height * 0.5)
						.background(Color(.systemGray5))
					}
				}
			}
			.tint(Color.black)
		}
		.listSectionSpacing(0)
		.navigationTitle(Strings.NewReceiptView.navigationTitle.text)
		.navigationBarTitleDisplayMode(.inline)
	}
}

//TODO: Add Preview
