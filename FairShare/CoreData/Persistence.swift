//
//  Persistence.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/6/24.
//

import CoreData

struct PersistenceController {
	static let shared = PersistenceController()

	static var preview: PersistenceController = {
		let result = PersistenceController(inMemory: true)
		let viewContext = result.container.viewContext

		for _ in 0..<10 {
			let newItem = Item(context: viewContext)
			newItem.timestamp = Date()
		}

		for _ in 0..<10 {
			let newContact = ContactData(context: viewContext)
			newContact.id = ContactModel.dummyData.id
			newContact.firstName = ContactModel.dummyData.firstName
			newContact.lastName = ContactModel.dummyData.lastName
			newContact.phoneNumber = ContactModel.dummyData.phoneNumber
		}

		do {
			try viewContext.save()
		} catch {
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}

		return result
	}()

	let container: NSPersistentContainer
	var context: NSManagedObjectContext { container.viewContext }

	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "FairShare")

		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}

		container.viewContext.automaticallyMergesChangesFromParent = true
		container.loadPersistentStores(
			completionHandler: { (storeDescription, error) in
				if let error = error as NSError? {
					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			}
		)

		container.viewContext.automaticallyMergesChangesFromParent = true
	}

	func saveContext() {
		if context.hasChanges {
			do {
				try context.save()
			} catch let error as NSError {
				NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
			}
		}
	}
}

///Contacts
extension PersistenceController {
	func fetchAllContacts() -> [ContactData] {
		let request = NSFetchRequest<ContactData>(entityName: "ContactData")

		do {
			return try context.fetch(request)
		} catch {
			return []
		}
	}

	func addContact(contact: ContactModel) {
		let newContact = ContactData(context: context)
		newContact.id = contact.id
		newContact.firstName = contact.firstName
		newContact.lastName = contact.lastName
		newContact.phoneNumber = contact.phoneNumber

		saveContext()
	}

	func deleteContact(_ contactData: ContactData) {
		context.delete(contactData)

		saveContext()
	}
}
