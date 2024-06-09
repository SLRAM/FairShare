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
	@Published var isLoading: Bool = true

	init() {
		self.userSession = AuthService.CurrentUser

		Task {
			try await self.fetchUser()
		}
	}

	func signIn(with email: String, password: String) async throws {
		do {
			let result = try await AuthService.signIn(with: email, password: password)
			self.userSession = result
			try await self.fetchUser()
		} catch let error as NSError {
			print(AuthErrorCode(_nsError: error).errorMessage)
			errorMessage = AuthErrorCode(_nsError: error).errorMessage
			showAlert = true
		}
	}

	func signOut() async throws {
		do {
			try await AuthService.signOut()
			self.userSession = nil
			self.currentUser = nil
		} catch let error {
			print("Error signing out user: \(error)")
			throw error
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
		} catch {
			print("Error fetching user: \(error)")
			throw error
		}
	}

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

	func createReceipt(from receiptTexts: [any ReceiptText]) async throws {
		do {
			try await DBService.createReceipt(from: receiptTexts, creatorID: self.currentUser!.id)
			try await self.fetchUserReceipts()
		} catch {
			print("Error writing document: \(error)")
			throw error
		}
	}
}
