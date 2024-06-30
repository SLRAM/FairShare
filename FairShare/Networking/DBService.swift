//
//  DBService.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/8/24.
//

import Foundation
import FirebaseFirestore
import Firebase

final class DBService {
	private init() {}

	public static var firestoreDB: Firestore = {
		let db = Firestore.firestore()
		let settings = db.settings
		db.settings = settings
		return db
	}()

	static public var generateDocumentId: String {
		return firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document().documentID
	}
}

///Authentication
extension DBService {
	static func createUser(from userModel: UserModel) async throws {
		do {
			let encodedUser = try Firestore.Encoder().encode(userModel)
			try await firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document(userModel.id).setData(encodedUser)
		} catch let error {
			print("Error creating user: \(error)")
			throw error
		}
	}

	static func fetchUser(userId: String) async throws -> UserModel {
		do {
			let snapshot = try await Firestore.firestore()
				.collection(Constants.UserCollectionKeys.CollectionKey)
				.document(userId)
				.getDocument()

			let user = try snapshot.data(as: UserModel.self)

			return user
		} catch {
			print("Error fetching user: \(error)")
			throw error
		}
	}
}

///Contacts
extension DBService {
	static func addContact(contact: ContactModel, creatorID: String) async throws {
		//TODO: encrypt phone numbers for safety.
		let contactsRef = firestoreDB.collection(Constants.ContactCollectionKeys.CollectionKey)
		let userRef = firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document(creatorID)
		let userContactsRef = userRef.collection(Constants.ContactCollectionKeys.CollectionKey)

		do {
			let querySnapshot = try await contactsRef
				.whereField(Constants.ContactCollectionKeys.PhoneNumberKey, isEqualTo: contact.phoneNumber)
				.getDocuments()

			if !querySnapshot.isEmpty {
				print("Contact with phone number \(contact.phoneNumber) already exists.")
				return
			}

			let docID = UUID()
			let contactData: [String: Any] = [
				Constants.ContactCollectionKeys.DocumentIdKey: docID.uuidString,
				Constants.ContactCollectionKeys.FirstNameKey: contact.firstName,
				Constants.ContactCollectionKeys.LastNameKey: contact.lastName,
				Constants.ContactCollectionKeys.PhoneNumberKey: contact.phoneNumber
			]

			try await contactsRef.document(docID.uuidString).setData(contactData)
			print("Contact Document successfully written.")

			try await userContactsRef.document(docID.uuidString).setData([
				Constants.ContactCollectionKeys.DocumentIdKey: docID.uuidString
			])
		} catch {
			print("Error writing contact document: \(error)")
			throw error
		}
	}

	static func fetchUserContacts(userID: String) async throws -> [ContactModel] {
		var contacts: [ContactModel] = []

		let userRef = firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document(userID)
		let userContactsRef = userRef.collection(Constants.ContactCollectionKeys.CollectionKey)

		do {
			let userContactsSnapshot = try await userContactsRef.getDocuments()

			for document in userContactsSnapshot.documents {
				let data = document.data()

				guard let contactID = data[Constants.ContactCollectionKeys.DocumentIdKey] as? String else {
					print("Error: Contact ID is nil for document \(document.documentID)")
					continue
				}

				let contactSnapshot = try await firestoreDB.collection(Constants.ContactCollectionKeys.CollectionKey).document(contactID).getDocument()

				if let contactData = contactSnapshot.data() {
					guard let id = contactData[Constants.ContactCollectionKeys.DocumentIdKey] as? String,
						  let firstName = contactData[Constants.ContactCollectionKeys.FirstNameKey] as? String,
						  let lastName = contactData[Constants.ContactCollectionKeys.LastNameKey] as? String,
						  let phoneNumber = contactData[Constants.ContactCollectionKeys.PhoneNumberKey] as? String else {

						print("Error: Required fields are missing for contact \(contactID)")
						continue
					}

					let contact = ContactModel(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
					contacts.append(contact)

				}
			}
		} catch {
			print("Error fetching user contacts: \(error)")
			throw error
		}

		return contacts
	}

}

///Receipts
extension DBService {
	static func createReceipt(from receiptTexts: [any ReceiptText], image: UIImage, creatorID: String) async throws {
		let docID = UUID()

		let receiptsRef = firestoreDB.collection(Constants.ReceiptCollectionKeys.CollectionKey)
		let userRef = firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document(creatorID)
		let userReceiptsRef = userRef.collection(Constants.ReceiptCollectionKeys.CollectionKey)

		do {
			guard let imageData = image.jpegData(compressionQuality: 1.0) else {
				print("Error converting image data.")
				return
			}

			let imageURL = try await StorageService.postImage(imageData: imageData, imageName: Constants.ReceiptImagePath + docID.uuidString)
			let receiptTextsData = receiptTexts.map { $0.toDictionary() }

			let receiptData: [String: Any] = [
				Constants.ReceiptCollectionKeys.DocumentIdKey: docID.uuidString,
				Constants.ReceiptCollectionKeys.CreatorIDKey: creatorID,
				Constants.ReceiptCollectionKeys.DateKey: Date(),
				Constants.ReceiptCollectionKeys.ImageURLKey: imageURL.absoluteString,
				Constants.ReceiptCollectionKeys.ItemsKey: receiptTextsData
			]

			try await receiptsRef.document(docID.uuidString).setData(receiptData)
			print("Receipt Document successfully written.")

			try await userReceiptsRef.document(docID.uuidString).setData([
				Constants.ReceiptCollectionKeys.DocumentIdKey: docID.uuidString
			])

			print("User's receipt reference successfully added.")
		} catch {
			print("Error writing document: \(error)")
			throw error
		}
	}

	static func fetchUserReceipts(userID: String) async throws -> [ReceiptModel] {
		var receipts: [ReceiptModel] = []
		let userRef = firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document(userID)
		let userReceiptsRef = userRef.collection(Constants.ReceiptCollectionKeys.CollectionKey)

		do {
			let userReceiptsSnapshot = try await userReceiptsRef.getDocuments()

			for document in userReceiptsSnapshot.documents {
				let data = document.data()

				guard let receiptID = data[Constants.ReceiptCollectionKeys.DocumentIdKey] as? String else {
					print("Error: Receipt ID is nil.")
					continue
				}

				let receiptSnapshot = try await firestoreDB.collection(Constants.ReceiptCollectionKeys.CollectionKey).document(receiptID).getDocument()

				if let receiptData = receiptSnapshot.data() {
					guard let idString = receiptData[Constants.ReceiptCollectionKeys.DocumentIdKey] as? String,
						  let id = UUID(uuidString: idString) else {
						print("Error: Invalid UUID string.")
						continue
					}

					guard let timestamp = receiptData[Constants.ReceiptCollectionKeys.DateKey] as? Timestamp else {
						print("Error: Invalid Timestamp.")
						continue
					}

					let date = timestamp.dateValue()

					guard let creatorID = receiptData[Constants.ReceiptCollectionKeys.CreatorIDKey] as? String else {
						print("Error: Invalid Creator ID.")
						continue
					}

					guard let imageUrlString = receiptData[Constants.ReceiptCollectionKeys.ImageURLKey] as? String else {
						print("Error: Invalid image URL.")
						continue
					}

					guard let itemsArray = receiptData[Constants.ReceiptCollectionKeys.ItemsKey] as? [[String: Any]] else {
						print("Error: Invalid items array.")
						continue
					}

					let jsonData = try JSONSerialization.data(withJSONObject: itemsArray, options: [])
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					let items = try decoder.decode([ReceiptItem].self, from: jsonData)

					let creatorSnapshot = try await firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document(creatorID).getDocument()
					let creator = try creatorSnapshot.data(as: UserModel.self)

					let receiptModel = ReceiptModel(id: id, creator: creator, date: date, imageURL: imageUrlString, items: items)

					receipts.append(receiptModel)
				}
			}
		} catch {
			print("Error fetching user receipts: \(error)")
			throw error
		}

		return receipts
	}
}
