//
//  NewReceiptView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Firebase
import PhotosUI
import SwiftUI

struct NewReceiptView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var authViewModel: AuthViewModel

	@State private var showActionSheet = true
	@State private var showCamera = false
	@State private var showGallery = false
	@State private var selectedImage: UIImage?
	@State private var selectedItem: PhotosPickerItem?
//	@State private var receiptItems: [ReceiptItem] = []
	@State private var receiptTexts: [any ReceiptText] = []

	@State private var isEditing = false
	@State private var showReceiptTab: Bool = false

	//TODO: remove imageToDisplay and visualizedImage. For testing purposes only.
	@State private var imageToDisplay: Image?
	@State private var visualizedImage: UIImage?

	var body: some View {
		NavigationStack {
			//TODO: remove imageToDisplay. For testing purposes only.
//			if let currentImage = imageToDisplay {
//				currentImage
//					.resizable()
//					.scaledToFit()
//					.frame(width: 300, height: 300)
//				ShareLink(item: currentImage, preview: SharePreview("Current Image", image: currentImage))
//			}
			
			ReceiptItemsView(receiptTexts: $receiptTexts, isEditing: $isEditing)
				.navigationBarTitleDisplayMode(.automatic)
				.toolbar {
					ToolbarItem(placement: .principal) {
						Strings.NewReceiptView.navigationTitle.text.font(.headline)
					}
					if !receiptTexts.isEmpty {
						ToolbarItem(placement: .topBarTrailing) {
							Button {
								isEditing.toggle()
							} label: {
								Strings.NewReceiptView.editButton.text
							}
						}
					}
				}
			
			if !receiptTexts.isEmpty {
				Button {
					dismiss()
				} label: {
					Strings.NewReceiptView.saveButton.text
				}
			}
		}
		.confirmationDialog("", isPresented: $showActionSheet) {
			Button(Strings.NewReceiptView.cameraButton) { showCamera.toggle() }
			Button(Strings.NewReceiptView.galleryButton) { showGallery.toggle() }
			Button(Strings.NewReceiptView.cancelButton, role: .cancel) { dismiss() }
		} message: {
			Strings.NewReceiptView.confirmationMessage.text
		}
		.photosPicker(
			isPresented: $showGallery,
			selection: $selectedItem,
			matching: .any(of: [.images, .screenshots, .livePhotos])
		)
		.fullScreenCover(
			isPresented: $showCamera,
			content: {
				CameraView(recognizedTexts: self.$receiptTexts, visualizedImage: self.$visualizedImage, selectedImage: self.$selectedImage)
					.edgesIgnoringSafeArea(.all)
			}
		)
		.onChange(of: selectedImage) {
			//TODO: remove imageToDisplay. For testing purposes only.
			///selectedImage will be saved for the final uploaded receipt.
			if let image = selectedImage {
				imageToDisplay = Image(uiImage: image)
			}
		}
		.onChange(of: selectedItem) {
			Task {
				let image = await Processor.extractImage(from: selectedItem)
				selectedImage = image
				receiptTexts = Processor.recognizeText(from: image)
			}
		}
	}
}

#Preview {
	NewReceiptView().environmentObject(AuthViewModel())
}
