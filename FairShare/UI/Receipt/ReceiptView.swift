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
			ZStack {
				if authViewModel.isLoading {
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.scaleEffect(1.5, anchor: .center)
				} else {
					//TODO: Update to ScrollView+LazyVStack to handle larger lists and account for spacing.
					List(authViewModel.receipts, id: \.id) { receipt in
						ReceiptCardView(receipt: receipt)
							.listRowSeparator(.hidden)
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
				}
			}
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
