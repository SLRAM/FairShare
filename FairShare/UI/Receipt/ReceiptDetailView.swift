//
//  ReceiptDetailView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/22/24.
//

import SwiftUI

struct ReceiptDetailView: View {
	var receipt: ReceiptModel
	@State private var isEnabled = false

	private func itemsByType() -> [[ReceiptItem]] {
		guard !receipt.items.isEmpty else { return [] }
		let dictionaryByType = Dictionary(grouping: receipt.items, by: { $0.type })
		let itemTypes = ReceiptItemType.allCases
		return itemTypes.compactMap({ dictionaryByType[$0] })
	}

	var body: some View {
		VStack(spacing: 0) {
			Toggle(isOn: $isEnabled) {
				Text(isEnabled ? Strings.ReceiptDetailView.onToggleTitle.string : Strings.ReceiptDetailView.defaultToggleTitle.string)
					.font(.headline)
			}
			.toggleStyle(CustomToggleStyle())
			.padding(.horizontal)
			.padding(.bottom, 5)

			GeometryReader { geometry in
				List {
					ForEach(itemsByType(), id: \.self) { itemInType in
						Section(header: Text(itemInType[0].type.rawValue)) {
							ForEach(itemInType) { item in
								HStack {
									Text(item.title)
									Spacer()
									Text(item.costAsCurrency)
								}
							}
						}
					}
					Section(header: Strings.ReceiptDetailView.imagesSectionTitle.text) {
						HStack {
							//TODO: add download option for images or whole breakdown
							//TODO: convert to carousel for multiple images
							Spacer()
							AsyncImage(url: URL(string: receipt.imageURL)) { phase in
								switch phase {
								case .empty:
									ProgressView()
								case .success(let image):
									image.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
								case .failure:
									EmptyView()
								@unknown default:
									EmptyView()
								}
							}

							Spacer()
						}
						.frame(height: geometry.size.height * 0.5)
						.background(Color(.systemGray5))
					}
				}
				.listSectionSpacing(0)
				.navigationTitle(receipt.date.toString(.full))
				.navigationBarTitleDisplayMode(.inline)
			}
		}
	}
}

#Preview {
	ReceiptDetailView(receipt: ReceiptModel.dummyData)
}
