//
//  AuthService.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/8/24.
//

import Foundation
import FirebaseAuth

final class AuthService {
	private init() {}

	public static var Authentication: Auth = {
		let auth = Auth.auth()
		return auth
	}()

	public static var CurrentUser: FirebaseAuth.User? {
		Authentication.currentUser
	}
}

extension AuthService {
	static func signIn(with email: String, password: String) async throws -> User {
		do {
			let result = try await Authentication.signIn(withEmail: email, password: password)
			return result.user
		} catch {
			throw error
		}
	}

	static func signOut() async throws {
		do {
			try Authentication.signOut()
		} catch {
			throw error
		}
	}

	static func createUser(withEmail: String, password: String) async throws -> AuthDataResult {
		do {
			let results = try await Authentication.createUser(withEmail: withEmail, password: password)
			return results
		} catch {
			throw error
		}
	}
}
