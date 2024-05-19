//
//  ReceiptView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI
import Firebase

struct ReceiptView: View {
	@EnvironmentObject var viewModel: AuthViewModel
	@State var showActionSheet = false

	var body: some View {
		NavigationStack {
			List(viewModel.receipts, id: \.id) { receipt in
				Text(receipt.date)
			}
			.navigationTitle("Previous Receipts")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showActionSheet = true
					} label: {
						Label(title: { Text("Label") }, icon: { Image(systemName: "plus") })
					}
				}
			}
			.confirmationDialog("New Receipt", isPresented: $showActionSheet) {
				Button("Camera") { print("Camera") }
				Button("Photo Gallery") { print("Photo Gallery") }
				Button("Cancel", role: .cancel) { }
			} message: {
				Text("Please take a new photo or select an image from the image gallery")
			}
		}
	}
}

#Preview {
	ReceiptView().environmentObject(AuthViewModel())
}
