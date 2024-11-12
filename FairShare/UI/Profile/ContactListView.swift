//
//  ContactListView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/9/24.
//

import CoreData
import SwiftUI

struct ContactListView: View {	
//	@Binding var selectedGuests: [ContactModel]
	@Environment(\.dismiss) var dismiss
	@Environment(\.managedObjectContext) private var viewContext
	@StateObject var viewModel: ContactViewModel

//	let listType: ContactViewModel.ListType

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				contactList
					.navigationTitle(Strings.ContactListView.navigationTitleProfile.string)
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .navigationBarTrailing) {
							Button(action: { viewModel.showContactPicker.toggle() }) {
								Images.System.plus.image
							}
						}
					}
					.overlay(
						EmptyStateView(
							isEmpty: viewModel.contacts.isEmpty,
							message: Strings.ContactListView.emptyState.string
						)
					)
				if viewModel.listType == .newReceipt {
					Button {
//						Task {
//							if let image = viewModel.selectedImage {
//								try await authViewModel.createReceipt(from: viewModel.receiptTexts, image: image)
//							}
//						}
						dismiss()
					} label: {
						Strings.NewReceiptView.saveButton.text
					}
				}
			}
			.fullScreenCover(isPresented: $viewModel.showContactPicker) {
				ContactPickerView(selectedContacts: $viewModel.selectedContacts)
					.edgesIgnoringSafeArea(.all)
			}
			.onAppear {
				viewModel.setContext(viewContext)
				viewModel.fetchContacts()
			}
			.onChange(of: viewModel.selectedContacts) {
				Task {
					viewModel.addContacts()
				}
		}
		}
	}

	private var contactList: some View {
		List {
			ForEach(viewModel.sortedSectionKeys, id: \.self) { key in
				Section(header: Text(key)) {
					ForEach(viewModel.groupedContacts[key] ?? [], id: \.self) { contact in
						ContactRow(contact: contact, viewModel: viewModel)
					}
				}
			}
		}
		.listSectionSpacing(0)
	}
}

struct ContactRow: View {
	let contact: ContactModel
	@ObservedObject var viewModel: ContactViewModel

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("\(contact.firstName) \(contact.lastName)")
					.font(.headline)
				Spacer()
				if viewModel.selectedContactIDs.contains(contact.id) {
					Images.System.checkmarkCircle.image
						.foregroundColor(.green)
				}
			}
			Text(contact.phoneNumber)
				.font(.subheadline)
				.foregroundColor(.gray)
		}
		.contentShape(Rectangle())
		.onTapGesture {
			if viewModel.listType == .newReceipt {
				viewModel.didTap(contact)
			}
		}
		.swipeActions(allowsFullSwipe: false) {
			Button(role: .destructive) {
//				 viewModel.deleteContact()
			} label: {
				Images.System.trashFill.image
			}
			Button {
//				viewModel.editContact()
			} label: {
				Strings.ContactListView.editButton.text
			}
			.tint(.green)
		}
	}

//	List {
//		ForEach(availablePayers, id: \.id) { payer in
//			HStack {
//				Text(payer.abbreviatedName)
//				Spacer()
//				if selectedPayerIDs.contains(payer.id) {
//					Images.System.checkmarkCircle.image
//						.foregroundColor(.green)
//				}
//			}
//			.contentShape(Rectangle())
//			.onTapGesture {
//				if selectedPayerIDs.contains(payer.id) {
//					selectedPayerIDs.remove(payer.id)
//				} else {
//					selectedPayerIDs.insert(payer.id)
//				}
//			}
//		}
//	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContactListView(viewModel: ContactViewModel(listType: .profile))
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
