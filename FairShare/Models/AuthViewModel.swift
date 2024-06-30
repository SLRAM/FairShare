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
	@Published var contacts: [ContactModel] = []
	@Published var showAlert = false
	@Published var errorMessage: String = ""
	@Published var isLoading: Bool = true

	init() {
		self.userSession = AuthService.CurrentUser

		Task {
			try await self.fetchUser()
		}
	}

	private func showError(for message: String) {
		errorMessage = message
		showAlert = true
	}
}

///Authentication
extension AuthViewModel {
	func signIn(with email: String, password: String) async throws {
		do {
			let result = try await AuthService.signIn(with: email, password: password)
			self.userSession = result
			try await self.fetchUser()
		} catch let error as FirebaseAuthError {
			self.showError(for: error.errorMessage)
		}
	}

	func signOut() async throws {
		do {
			try await AuthService.signOut()
			self.userSession = nil
			self.currentUser = nil
		} catch let error as FirebaseAuthError {
			self.showError(for: error.errorMessage)
		}
	}

	func createUser(with email: String, password: String, firstName: String, lastName: String) async throws {
		do {
			if !self.receipts.isEmpty {
				self.receipts = []
			}
			let result = try await AuthService.createUser(withEmail: email, password: password)
			self.userSession = result.user
			let user = UserModel(id: result.user.uid, firstName: firstName, lastName: lastName, email: email)

			try await DBService.createUser(from: user)
			try await self.fetchUser()
		} catch {
			print("Error creating user: \(error)")
			throw error
		}
	}

	func deleteAccount() {

	}

	private func fetchUser() async throws {
		guard let userId = AuthService.CurrentUser?.uid else {
			print("Error: User ID is nil.")
			return
		}

		self.isLoading = true

		do {
			let fetchedUser = try await DBService.fetchUser(userId: userId)
			self.currentUser = fetchedUser
			try await self.fetchUserReceipts()
			try await self.fetchContacts()
		} catch {
			print("Error fetching user: \(error)")
			throw error
		}
	}
}

///Receipt
extension AuthViewModel {
	func fetchUserReceipts() async throws {
		guard let userID = self.currentUser?.id else {
			print("Error: Current user ID is nil.")
			return
		}

		do {
			let fetchedReceipts = try await DBService.fetchUserReceipts(userID: userID)
			self.receipts = fetchedReceipts.sorted { $0.date > $1.date }
		} catch {
			print("Error fetching user receipts: \(error)")
			throw error
		}

		isLoading = false
	}

	func createReceipt(from receiptTexts: [any ReceiptText], image: UIImage) async throws {
		do {
			try await DBService.createReceipt(from: receiptTexts, image: image, creatorID: self.currentUser!.id)
			try await self.fetchUserReceipts()
		} catch {
			print("Error writing document: \(error)")
			throw error
		}
	}
}

///Contacts
extension AuthViewModel {
	func addContacts(contacts: [ContactModel]) async throws {
		do {
			for contact in contacts {
				try await DBService.addContact(contact: contact, creatorID: self.currentUser!.id)
			}
		} catch {
			print("Error writing document: \(error)")
			throw error
		}
	}

	func fetchContacts() async throws {
		guard let userID = self.currentUser?.id else {
			print("Error: Current user ID is nil.")
			return
		}

		do {
			let fetchedContacts = try await DBService.fetchUserContacts(userID: userID)
			self.contacts = fetchedContacts.sorted { $0.firstName > $1.firstName }
		} catch {
			print("Error fetching user contacts: \(error)")
			throw error
		}
	}
}
