//
//  ContactViewModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/11/24.
//

import CoreData
import Foundation

class ContactViewModel: ObservableObject {
	//TODO: Update error handling
	@Published var contacts: [ContactModel] = []
	@Published var showContactPicker = false
	@Published var selectedContacts: [ContactModel] = []
//	@Published var fetchedContactss: [ContactData] = []

	private var context: NSManagedObjectContext?

	var groupedContacts: [String: [ContactModel]] {
		Dictionary(grouping: contacts, by: { String($0.firstName.prefix(1)) })
	}

	var sortedSectionKeys: [String] {
		groupedContacts.keys.sorted()
	}

///Context
	func setContext(_ context: NSManagedObjectContext) {
		self.context = context
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

///Contacts
	func fetchContacts() {
		guard let context = context else { return }
		let fetchRequest: NSFetchRequest<ContactData> = ContactData.fetchRequest()

		do {
			let fetchedContacts = try context.fetch(fetchRequest)
//			fetchedContactss = fetchedContacts
			self.contacts = convertToContactModels(from: fetchedContacts)

		} catch {
			print("Failed to fetch contacts: \(error.localizedDescription)")
		}
	}

	func addContacts() {
		guard let context = context, !selectedContacts.isEmpty else {
			return
		}

		for contact in selectedContacts {
			let newContact = ContactData(context: context)
			newContact.id = contact.id
			newContact.firstName = contact.firstName
			newContact.lastName = contact.lastName
			newContact.phoneNumber = contact.phoneNumber
		}

		saveContext()
		fetchContacts()
	}

//TODO: update or replace ContactModel with ContactData to allow for smooth deletion
//	func deleteContact(_ contact: ContactData) {
//		guard let context = context else {
//			return
//		}
//
//		context.delete(contact)
//		saveContext()
//		fetchContacts()
//	}

//	func deleteContact() {
//		guard let context = context else {
//			return
//		}
//
//		context.delete(fetchedContactss[0])
//
//		saveContext()
//		fetchContacts()
//	}

	func convertToContactModels(from contactDataArray: [ContactData]) -> [ContactModel] {
		return contactDataArray.map { ContactModel($0) }
	}
}
