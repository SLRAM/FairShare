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
	@StateObject private var viewModel = NewReceiptViewModel()

	var body: some View {
		NavigationStack {
			VStack {
				ReceiptItemsView(
					itemsByType: viewModel.itemsByType(),
					isEditing: $viewModel.isEditing,
					receiptTexts: $viewModel.receiptTexts,
					itemTapped: viewModel.itemTapped,
					imageToDisplay: viewModel.imageToDisplay
				)
				.toolbar {
					if !viewModel.receiptTexts.isEmpty {
						ToolbarItem(placement: .topBarTrailing) {
							Button { viewModel.isEditing.toggle()
							} label: {
								Strings.NewReceiptView.editButton.text
							}
						}
					}
				}

				if !viewModel.receiptTexts.isEmpty {
					Button {
						Task {
							if let image = viewModel.selectedImage {
								try await authViewModel.createReceipt(from: viewModel.receiptTexts, image: image)
							}
						}
						dismiss()
					} label: {
						Strings.NewReceiptView.saveButton.text
					}
				}
			}
		}
		.confirmationDialog("", isPresented: $viewModel.showActionSheet) {
			Button(Strings.NewReceiptView.cameraButton) { viewModel.showCamera.toggle() }
			Button(Strings.NewReceiptView.galleryButton) { viewModel.showGallery.toggle() }
			Button(Strings.NewReceiptView.cancelButton, role: .cancel) { dismiss() }
		} message: {
			Strings.NewReceiptView.confirmationMessage.text
		}
		.photosPicker(
			isPresented: $viewModel.showGallery,
			selection: $viewModel.selectedItem,
			matching: .any(of: [.images, .screenshots, .livePhotos])
		)
		.fullScreenCover(
			isPresented: $viewModel.showCamera,
			content: {
				CameraView(recognizedTexts: $viewModel.receiptTexts, visualizedImage: $viewModel.visualizedImage, selectedImage: $viewModel.selectedImage)
					.edgesIgnoringSafeArea(.all)
			}
		)
		.onChange(of: viewModel.selectedImage) {
			if let image = viewModel.selectedImage {
				viewModel.imageToDisplay = Image(uiImage: image)
			}
		}
		.onChange(of: viewModel.selectedItem) {
			Task {
				let image = await Processor.extractImage(from: viewModel.selectedItem)
				viewModel.selectedImage = image
				viewModel.receiptTexts = Processor.recognizeText(from: image)
			}
		}
	}
}

#Preview {
	NewReceiptView().environmentObject(AuthViewModel())
}
