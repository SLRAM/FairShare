//
//  ReceiptView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Firebase
import PhotosUI
import SwiftUI

struct ReceiptView: View {
	@EnvironmentObject var authViewModel: AuthViewModel
	@State private var showActionSheet = false
	@State private var showCamera = false
	@State private var showGallery = false
	@State private var selectedImage: UIImage?
	@State private var selectedItem: PhotosPickerItem?
	@State private var imageToDisplay: Image?

	var body: some View {
		NavigationStack {
			//TODO: remove imageToDisplay. For testing purposes only.
			imageToDisplay?
				.resizable()
				.scaledToFit()
				.frame(width: 300, height: 300)

			List(authViewModel.receipts, id: \.id) { receipt in
				Text(receipt.date)
			}
			.navigationTitle("Previous Receipts")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showActionSheet.toggle()
					} label: {
						Label(title: {}, icon: { Image(systemName: "plus") })
					}
				}
			}
			.confirmationDialog("New Receipt", isPresented: $showActionSheet) {
				Button("Camera") { showCamera.toggle()}
				Button("Photo Gallery") { showGallery.toggle()}
				Button("Cancel", role: .cancel) { }
			} message: {
				Text("Please take a new photo or select an image from the image gallery")
			}
		}
		.photosPicker(
			isPresented: $showGallery,
			selection: $selectedItem,
			matching: .any(of: [.images, .screenshots, .livePhotos])
		)
		.fullScreenCover(
			isPresented: $showCamera,
			content: {
				CameraView(selectedImage: self.$selectedImage)
					.edgesIgnoringSafeArea(.all)
			}
		)
		.onChange(of: selectedImage) {
			//TODO: remove imageToDisplay. For testing purposes only.
			if let image = selectedImage {
				imageToDisplay = Image(uiImage: image)
			}
		}
		.onChange(of: selectedItem) {
			Task {
				if let item = selectedItem {
					if let data = try? await item.loadTransferable(type: Data.self) {
						selectedImage = UIImage(data: data)
					}
				}
			}
		}
	}
}

#Preview {
	ReceiptView().environmentObject(AuthViewModel())
}
