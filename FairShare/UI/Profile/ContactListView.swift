//
//  ContactListView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/9/24.
//

import CoreData
import SwiftUI

struct ContactListView: View {	
//	@Environment(\.dismiss) var dismiss
	@Environment(\.managedObjectContext) private var viewContext
	@StateObject var viewModel: ContactViewModel
//	let saveTapped: ([ContactModel]) -> Void
	var saveTapped: (([ContactModel]) -> Void)?

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
						//here I will prompt func that will check all saved ids and pull matching models from contactModels to pass to next view
						if let saveTapped = saveTapped {
							saveTapped(viewModel.filterGuests())
						}

//						dismiss()
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
		HStack {
			VStack(alignment: .leading) {
				Text("\(contact.firstName) \(contact.lastName)")
					.font(.headline)
				if viewModel.listType == .profile {
					Text(contact.phoneNumber)
						.font(.subheadline)
						.foregroundColor(.gray)
				}
			}

			Spacer()
			if viewModel.selectedContactIDs.contains(contact.id) {
				Images.System.checkmarkCircle.image
					.foregroundColor(.green)
			}
		}
		.contentShape(Rectangle())
		.onTapGesture {
			if viewModel.listType == .newReceipt {
				viewModel.didTap(contact)
			}
		}
		.swipeActions(allowsFullSwipe: false) {
			if viewModel.listType == .profile {
				Button(role: .destructive) {
//					 viewModel.deleteContact()
				} label: {
					Images.System.trashFill.image
				}
				Button {
//					viewModel.editContact()
				} label: {
					Strings.ContactListView.editButton.text
				}
				.tint(.green)
			}

		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContactListView(viewModel: ContactViewModel(listType: .profile), saveTapped: { _ in })
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
