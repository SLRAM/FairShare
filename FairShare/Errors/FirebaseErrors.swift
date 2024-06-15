//
//  FirebaseErrors.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/12/24.
//

import Foundation
import Firebase

protocol DBError: Error {}

enum FirebaseAuthError: DBError {
	case emailAlreadyInUse
	case userNotFound
	case userDisabled
	case invalidEmail
	case networkError
	case weakPassword
	case wrongPassword
	case operationNotAllowed
	case unknownError(String)

	init(_ error: NSError) {
		let authErrorCode = AuthErrorCode(_nsError: error).code

		switch authErrorCode {
		case .emailAlreadyInUse:
			self = .emailAlreadyInUse
		case .userNotFound:
			self = .userNotFound
		case .userDisabled:
			self = .userDisabled
		case .invalidEmail, .invalidSender, .invalidRecipientEmail:
			self = .invalidEmail
		case .networkError:
			self = .networkError
		case .weakPassword:
			self = .weakPassword
		case .wrongPassword:
			self = .wrongPassword
		case .operationNotAllowed:
			self = .operationNotAllowed
		default:
			self = .unknownError("\(authErrorCode)")
		}
	}

	var errorMessage: String {
		switch self {
		case .emailAlreadyInUse:
			return "This email is already in use with another account."
		case .userNotFound:
			return "Account not found for the specified user. Please check and try again."
		case .userDisabled:
			return "Your account has been disabled. Please contact support."
		case .invalidEmail:
			return "Please enter a valid email."
		case .networkError:
			return "Network error. Please try again."
		case .weakPassword:
			return "Your password is too weak. The password must be 6 characters long or more."
		case .wrongPassword:
			return "Your password is incorrect. Please try again."
		case .operationNotAllowed:
			return "Sign in with this method is currently disabled. Please contact support for further assistance."
		case .unknownError(let code):
			return "Unknown error occurred. Error code: \(code)"
		}
	}
}
