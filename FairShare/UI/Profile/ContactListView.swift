//
//  ContactListView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/9/24.
//

import CoreData
import SwiftUI

//struct ContactListView: View {
//	enum ListType {
//		case profile
//		case newReceipt
//	}
////	@Binding var receiptTexts: [any ReceiptText]
//	@Environment(\.managedObjectContext) private var viewContext
//	@StateObject private var viewModel = ContactViewModel()
//	let listType: ListType
//
//	var body: some View {
//		VStack(spacing: 0) {
//			List {
//				ForEach(viewModel.sortedSectionKeys, id: \.self) { key in
//					Section(header: Text(key)) {
//						ForEach(viewModel.groupedContacts[key] ?? [], id: \.self) { contact in
//							VStack(alignment: .leading) {
//								Text("\(contact.firstName) \(contact.lastName)")
//									.font(.headline)
//								Text(contact.phoneNumber)
//									.font(.subheadline)
//									.foregroundColor(.gray)
//							}
//							.padding(.vertical, 4)
//							.swipeActions(allowsFullSwipe: false) {
//								Button(role: .destructive) {
//									viewModel.deleteContact()
//								} label: {
//									Images.System.trashFill.image
//								}
//
//								Button {
////									viewModel.editContact()
//								} label: {
//									Strings.ContactListView.editButton.text
//								}
//								.tint(.green)
//							}
//						}
//					}
//				}
//			}
//			.listSectionSpacing(0)
////			.navigationTitle(Strings.ContactListView.navigationTitle.string)
//			.navigationBarTitleDisplayMode(.inline)
//			.toolbar {
//				ToolbarItem(placement: .navigationBarTrailing) {
//					Button {
//						viewModel.showContactPicker.toggle()
//					} label: {
//						Images.System.plus.image
//					}
//				}
//			}
//			.overlay(
//				Group {
//					if viewModel.contacts.isEmpty {
//						Strings.ContactListView.emptyState.text
//					}
//				}
//			)
//		}
//		.fullScreenCover(
//			isPresented: $viewModel.showContactPicker,
//			content: {
//				ContactPickerView(selectedContacts: $viewModel.selectedContacts)
//					.edgesIgnoringSafeArea(.all)
//			}
//		)
//		.onAppear {
//			viewModel.setContext(viewContext)
//			viewModel.fetchContacts()
//		}
//		.onChange(of: viewModel.selectedContacts) {
//			Task {
//				viewModel.addContacts()
//			}
//		}
//	}
//}
//
//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContactListView()
//			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//	}
//}

import CoreData
import SwiftUI

struct ContactListView: View {
	enum ListType {
		case profile
		case newReceipt
	}
//	@Binding var selectedGuests: [ContactModel]
	@Environment(\.managedObjectContext) private var viewContext
	@StateObject private var viewModel = ContactViewModel()

	let listType: ListType

	var body: some View {
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
			Text("\(contact.firstName) \(contact.lastName)")
				.font(.headline)
			Text(contact.phoneNumber)
				.font(.subheadline)
				.foregroundColor(.gray)
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
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContactListView(listType: .profile)
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
