//
//  ReceiptView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Firebase
import SwiftUI

struct ReceiptView: View {
	@EnvironmentObject var authViewModel: AuthViewModel

	@State private var isPresented = false

	var body: some View {
		NavigationStack {
			ZStack {
				if authViewModel.isLoading {
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.scaleEffect(1.5, anchor: .center)
				} else {
					ScrollView {
						LazyVStack(spacing: 10) {
							ForEach(authViewModel.receipts, id: \.id) { receipt in
								NavigationLink(value: receipt) {
									ReceiptCardView(receipt: receipt)
								}
								.foregroundColor(.black)
							}
						}
						.padding()
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
			.navigationTitle(Strings.ReceiptView.navigationTitle.text)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						isPresented.toggle()
					} label: {
						Images.System.plus.image
					}
				}
			}
			.fullScreenCover(isPresented: $isPresented) {
				NewReceiptView()
			}
			.navigationDestination(for: ReceiptModel.self) { receipt in
				ReceiptDetailView(
					viewModel:
						ReceiptDetailViewModel(
							receipt: receipt,
							userID: authViewModel.currentUserID()
						)
				)
			}
		}
	}
}

#Preview {
	ReceiptView().environmentObject(AuthViewModel())
}
