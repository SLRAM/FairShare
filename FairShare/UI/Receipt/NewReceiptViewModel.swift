//
//  NewReceiptViewModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/30/24.
//

import PhotosUI
import SwiftUI

class NewReceiptViewModel: ObservableObject {
	@Published var showActionSheet = true
	@Published var showCamera = false
	@Published var showGallery = false
	@Published var selectedImage: UIImage?
	@Published var selectedItem: PhotosPickerItem?
	@Published var receiptTexts: [any ReceiptText] = []

	@Published var isEditing = false
	@Published var showReceiptTab: Bool = false

	@Published var imageToDisplay: Image?
	@Published var visualizedImage: UIImage?

	@Published var isEnabled = false
	@Published var selectedReceiptItem: ReceiptItem?
	@Published var isSideMenuShowing = false

	func itemsByType() -> [[ReceiptItem]] {
		let receiptItems = receiptTexts.compactMap { $0 as? ReceiptItem }
		guard !receiptItems.isEmpty else { return [] }
		let dictionaryByType = Dictionary(grouping: receiptItems, by: { $0.type })
		let itemTypes = ReceiptItemType.allCases
		return itemTypes.compactMap { dictionaryByType[$0] }
	}

	func updateSelectedItem(_ newItem: PhotosPickerItem?) async {
		selectedItem = newItem
		if let newItem = newItem {
			let image = await Processor.extractImage(from: newItem)
			selectedImage = image
			receiptTexts = Processor.recognizeText(from: image)
		}
	}

	func updateSelectedImage(_ newImage: UIImage?) {
		selectedImage = newImage
		if let newImage = newImage {
			imageToDisplay = Image(uiImage: newImage)
		}
	}

	func itemTapped(item: ReceiptItem) {
		if item.type == .item {
			selectedReceiptItem = item
		}
	}

	func contactsTapped(contactIds: [String]) {
		selectedReceiptItem?.payerIDs = contactIds
	}
}
