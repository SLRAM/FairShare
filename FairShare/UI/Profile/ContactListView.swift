//
//  ContactListView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/9/24.
//

import CoreData
import SwiftUI

struct ContactListView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@StateObject private var viewModel = ContactViewModel()
	@State private var showContactPicker = false
	@State private var selectedContacts: [ContactModel] = []

	private var groupedContacts: [String: [ContactModel]] {
		Dictionary(grouping: viewModel.contacts, by: { String($0.firstName.prefix(1)) })
	}

	private var sortedSectionKeys: [String] {
		groupedContacts.keys.sorted()
	}

	var body: some View {
		VStack(spacing: 0) {
			List {
				ForEach(sortedSectionKeys, id: \.self) { key in
					Section(header: Text(key)) {
						ForEach(groupedContacts[key] ?? [], id: \.self) { contact in
							VStack(alignment: .leading) {
								Text("\(contact.firstName) \(contact.lastName)")
									.font(.headline)
								Text(contact.phoneNumber)
									.font(.subheadline)
									.foregroundColor(.gray)
							}
							.padding(.vertical, 4)
							.swipeActions(allowsFullSwipe: false) {
								Button(role: .destructive) {
									print("Deleting contact \(contact.firstName)")
								} label: {
									Label("Delete", systemImage: "trash.fill")
								}

								Button {
									print("Edit \(contact.firstName)")
								} label: {
									Text("Edit")
								}
								.tint(.green)
							}
						}
					}
				}
			}
			.navigationTitle("Contacts")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showContactPicker.toggle()
					} label: {
						Image(systemName: "plus")
							.foregroundColor(.blue)
					}
				}
			}
		}
		.fullScreenCover(
			isPresented: $showContactPicker,
			content: {
				ContactPickerView(selectedContacts: $selectedContacts)
					.edgesIgnoringSafeArea(.all)
			}
		)
		.onAppear {
			viewModel.setContext(viewContext)
			viewModel.fetchContacts()
		}
		.onChange(of: selectedContacts) {
			Task {
				viewModel.addContacts(selectedContacts)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContactListView()
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}

class ContactViewModel: ObservableObject {
	@Published var contacts: [ContactModel] = []

	private var context: NSManagedObjectContext?

	func setContext(_ context: NSManagedObjectContext) {
		self.context = context
	}

	func fetchContacts() {
		guard let context = context else { return }
		let fetchRequest: NSFetchRequest<ContactData> = ContactData.fetchRequest()

		do {
			let fetchedContacts = try context.fetch(fetchRequest)
			self.contacts = convertToContactModels(from: fetchedContacts)

		} catch {
			print("Failed to fetch contacts: \(error.localizedDescription)")
		}
	}

	func addContacts(_ contacts: [ContactModel]) {
		guard let context = context else {
			return
		}

		for contact in contacts {
			let newContact = ContactData(context: context)
			newContact.id = contact.id
			newContact.firstName = contact.firstName
			newContact.lastName = contact.lastName
			newContact.phoneNumber = contact.phoneNumber
		}

		saveContext()
		fetchContacts()
	}

	private func saveContext() {
		guard let context = context else {
			return
		}

		do {
			try context.save()
		} catch {
			print("Failed to save context: \(error.localizedDescription)")
		}
	}

//TODO: replace ContactModel with ContactData to allow for smooth deletion
	
//	func deleteContact(_ contact: ContactData) {
//		guard let context = context else {
//			return
//		}
//
//		context.delete(contact)
//		saveContext()
//		fetchContacts()
//	}

	func convertToContactModels(from contactDataArray: [ContactData]) -> [ContactModel] {
		return contactDataArray.map { ContactModel($0) }
	}
}
