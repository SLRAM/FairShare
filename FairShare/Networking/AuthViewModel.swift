//
//  AuthViewModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@MainActor
class AuthViewModel: ObservableObject {
	@Published var userSession: FirebaseAuth.User?
	@Published var currentUser: UserModel?
	@Published var receipts: [ReceiptModel] = []
	@Published var showAlert = false
	@Published var errorMessage: String = ""

	init() {
		self.userSession = Auth.auth().currentUser

		Task {
			await fetchUser()
		}
	}

	func signIn(with email: String, password: String) async throws {
		do {
			let result = try await Auth.auth().signIn(withEmail: email, password: password)
			self.userSession = result.user
			await fetchUser()
		} catch let error as NSError {
			print(AuthErrorCode(_nsError: error).errorMessage)
			errorMessage = AuthErrorCode(_nsError: error).errorMessage
			showAlert = true
		}
	}

	func createUser(with email: String, password: String, firstName: String, lastName: String) async throws {
		do {
			let result = try await Auth.auth().createUser(withEmail: email, password: password)
			self.userSession = result.user
			let user = UserModel(id: result.user.uid, firstName: firstName, lastName: lastName, email: email)
			let encodedUser = try Firestore.Encoder().encode(user)

			try await Firestore.firestore().collection("Users").document(user.id).setData(encodedUser)
			await fetchUser()
		} catch let error as NSError {
			print(AuthErrorCode(_nsError: error).errorMessage)
			errorMessage = AuthErrorCode(_nsError: error).errorMessage
			showAlert = true
		}
	}

	func signOut() {
		do {
			try Auth.auth().signOut()
			self.userSession = nil
			self.currentUser = nil
		} catch let error as NSError {
			print(AuthErrorCode(_nsError: error).errorMessage)
		}
	}

	func deleteAccount() {

	}

	private func fetchUser() async {
		guard let uid = Auth.auth().currentUser?.uid else { return }

		guard let snapshot = try? await Firestore.firestore().collection("Users").document(uid).getDocument() else { return }
		self.currentUser = try? snapshot.data(as: UserModel.self)
		print("DEBUG: Current user is \(String(describing: self.currentUser))")
	}

	func fetchReceipts() {
		let db = Firestore.firestore()
		let ref = db.collection("Receipts")
		ref.getDocuments { snapshot, error in
			guard error == nil else {
				print(error!.localizedDescription)
				return
			}
			if let snapshot = snapshot {
				for document in snapshot.documents {
					let data = document.data()

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
