//
//  SideMenuView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 7/6/24.
//

import SwiftUI

struct SideMenuView: View {
	//TODO: add animation on Disappear. Create ViewModel.
	@Binding var isShowing: Bool
	@Binding var currentItem: ReceiptItem?
	@Binding var availablePayers: [any PayerProtocol]
	@Binding var currentGuestIDs: Set<String>
	@State private var selectedPayerIDs: Set<String> = []

	var body: some View {
		ZStack {
			if isShowing, let currentItem = currentItem  {
				Color.black.opacity(0.3)
					.edgesIgnoringSafeArea(.all)
				VStack(spacing: 0) {
					HStack(spacing: 0) {
						Spacer()
						Strings.SideMenuView.viewTitle.text
							.font(.headline)
						Spacer()
					}
					.padding()

					List {
						ForEach(availablePayers, id: \.id) { payer in
							HStack {
								Text(payer.abbreviatedName)
								Spacer()
								if selectedPayerIDs.contains(payer.id) {
									Images.System.checkmarkCircle.image
										.foregroundColor(.green)
								}
							}
							.contentShape(Rectangle())
							.onTapGesture {
								if selectedPayerIDs.contains(payer.id) {
									selectedPayerIDs.remove(payer.id)
								} else {
									selectedPayerIDs.insert(payer.id)
								}
							}
						}
					}

					Button {
						currentItem.payerIDs = Array(selectedPayerIDs)
						self.currentItem = nil
					} label: {
						Strings.SideMenuView.doneButton.text
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color(.systemGray6))
							.foregroundColor(.blue)
							.cornerRadius(8)
					}
					.padding()
				}
				.onAppear {
					if let payerIDs = currentItem.payerIDs {
						selectedPayerIDs = Set(payerIDs)
					}
				}
				.onDisappear {
					//TODO: Account for when a user removes a guest. They should not be passed to currentGuestIDs if they are not listed on currentItem.payerIDs
					currentGuestIDs.formUnion(selectedPayerIDs)
				}
				.background(Color.white)
				.cornerRadius(12)
				.padding()
				.transition(.move(edge: .leading))
			}
		}
	}
}

//TODO: Add Preview
