//
//  ReceiptView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Firebase
import SwiftUI

struct ReceiptView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@EnvironmentObject var authViewModel: AuthViewModel
	@StateObject private var viewModel: ReceiptListViewModel

//	@State private var isPresented = false

	init() {
		_viewModel = StateObject(wrappedValue: ReceiptListViewModel(availablePayers: []))
	}

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
						EmptyStateView(
							isEmpty: authViewModel.receipts.isEmpty,
							message: Strings.ReceiptView.emptyState.string
						)
					)
				}
			}
			.navigationTitle(Strings.ReceiptView.navigationTitle.text)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						viewModel.contactsListIsPresented.toggle()
					} label: {
						Images.System.plus.image
					}
				}
			}
			.fullScreenCover(isPresented: $viewModel.contactsListIsPresented) {
					ContactListView(
						viewModel: ContactViewModel(
							listType: .newReceipt
						),
						saveTapped: viewModel.addGuests
					)
						.environment(\.managedObjectContext, viewContext)
				
			}
			.fullScreenCover(isPresented: $viewModel.newReceiptIsPresented) {
					NewReceiptView()
//						.environmentObject(AuthViewModel())
			}
			.navigationDestination(for: ReceiptModel.self) { receipt in
				ReceiptDetailView(
					viewModel:
						ReceiptDetailViewModel(
							receipt: receipt,
							userID: authViewModel.currentUserID()
						),
					guests: $authViewModel.fetchedReceiptGuests
				)
				.onAppear {
//					Task {
//						try await authViewModel.fetchCurrentReceiptGuests(for: receipt)
//					}
				}
			}
		}
		.onAppear {
			viewModel.availablePayers = authViewModel.availablePayers
		}
	}
}

#Preview {
	ReceiptView()
		.environmentObject(AuthViewModel())
		.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
