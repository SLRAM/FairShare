//
//  DataManager.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
	@Published var users: [UserModel] = []
	@Published var receipts: [ReceiptModel] = []

	init() {
		fetchUsers()
		fetchReceipts()
	}
	
	func fetchUsers() {
		users.removeAll()
		let db = Firestore.firestore()
		let ref = db.collection("Users")
		ref.getDocuments { snapshot, error in
			guard error == nil else {
				print(error!.localizedDescription)
				return
			}
			if let snapshot = snapshot {
				for docunment in snapshot.documents {
					let data = docunment.data()

					let id = data["id"] as? String ?? ""
					let firstName = data["firstName"] as? String ?? ""
					let lastName = data["lastName"] as? String ?? ""
					let email = data["email"] as? String ?? ""
					let user = UserModel(id: id, firstName: firstName, lastName: lastName, email: email)
					self.users.append(user)
				}
			}
		}
	}

	func fetchReceipts() {
		users.removeAll()
		let db = Firestore.firestore()
		let ref = db.collection("Receipts")
		ref.getDocuments { snapshot, error in
			guard error == nil else {
				print(error!.localizedDescription)
				return
			}
			if let snapshot = snapshot {
				for docunment in snapshot.documents {
					let data = docunment.data()

					let id = data["id"] as? String ?? ""
					let date = data["date"] as? String ?? ""
					let subtotal = data["subtotal"] as? Double ?? 0.0
					let tax = data["tax"] as? Double ?? 0.0
					let tip = data["tip"] as? Double ?? 0.0
					let total = data["total"] as? Double ?? 0.0
					let receipt = ReceiptModel(id: id, date: date, subtotal: subtotal, tax: tax, tip: tip, total: total)
					self.receipts.append(receipt)
				}
			}
		}
	}
}

class AuthViewModel: ObservableObject {
	@Published var userSession: FirebaseAuth.User?
	@Published var currentUser: User?

	init() {

	}

	func signIn(with email: String, password: String) async throws {

	}

	func createUser(with email: String, password: String, firstName: String, lastName: String) async throws {

	}

	func signOut() {

	}

	func deleteAccount() {

	}

	func fetchUser() async {
		
	}
}
