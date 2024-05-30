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
	
	@State private var selectedReceipt: ReceiptModel? = nil
	@State private var isPresented = false

	var body: some View {
		NavigationStack {
			List(authViewModel.receipts, id: \.id) { receipt in
				Text(receipt.date)
					.onTapGesture {
						selectedReceipt = receipt
					}
			}
			.overlay(
				Group {
					if authViewModel.receipts.isEmpty {
						Strings.ReceiptView.emptyState.text
					}
				}
			)
			.toolbar {
				ToolbarItem(placement: .principal) {
					Strings.ReceiptView.navigationTitle.text.font(.headline)
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						isPresented.toggle()
					} label: {
						Images.System.plus.image
					}
				}
			}
		}
		.fullScreenCover(isPresented: $isPresented) {
			NewReceiptView()
		}
	}
}

#Preview {
	ReceiptView().environmentObject(AuthViewModel())
}
