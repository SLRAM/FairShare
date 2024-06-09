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

				guard let user = try? snapshot.data(as: UserModel.self) else {
					throw NSError(domain: "User model error", code: 404, userInfo: nil)
				}

				return user
			} catch {
				print("Error fetching user: \(error)")
				throw error
			}
		}

}

///Receipts
extension DBService {
	static func createReceipt(from receiptTexts: [any ReceiptText], creatorID: String) async throws {
		//TODO: Add receiptTexts to ReceiptModel
		let docID = UUID()

		let receiptsRef = firestoreDB.collection(Constants.ReceiptCollectionKeys.CollectionKey)
		let userRef = firestoreDB.collection(Constants.UserCollectionKeys.CollectionKey).document(creatorID)
		let userReceiptsRef = userRef.collection(Constants.ReceiptCollectionKeys.CollectionKey)

		do {
			try await receiptsRef.document(docID.uuidString).setData([
				Constants.ReceiptCollectionKeys.DocumentIdKey: docID.uuidString,
				Constants.ReceiptCollectionKeys.CreatorIDKey: creatorID,
				Constants.ReceiptCollectionKeys.DateKey: Timestamp(date: Date())
			])

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

					//					let date = receiptData[Constants.ReceiptCollectionKeys.DateKey] as? Date ?? Date()
					guard let timestamp = receiptData[Constants.ReceiptCollectionKeys.DateKey] as? Timestamp else {
						print("Error: Invalid Timestamp.")
						continue
					}
					
					let date = timestamp.dateValue()

					let creatorID = receiptData[Constants.ReceiptCollectionKeys.CreatorIDKey] as? String ?? ""
					let receiptModel = ReceiptModel(id: id, creatorID: creatorID, date: date)

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