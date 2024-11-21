//
//  NSError+Helper.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 7/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

extension NSError {
	func asFirebaseAuthError() -> FirebaseAuthError {
		let authErrorCode = AuthErrorCode(_nsError: self).code
		switch authErrorCode {
		case .emailAlreadyInUse:
			return .emailAlreadyInUse
		case .userNotFound:
			return .userNotFound
		case .userDisabled:
			return .userDisabled
		case .invalidEmail, .invalidSender, .invalidRecipientEmail:
			return .invalidEmail
		case .networkError:
			return .networkError
		case .weakPassword:
			return .weakPassword
		case .wrongPassword:
			return .wrongPassword
		case .operationNotAllowed:
			return .operationNotAllowed
		case .keychainError:
			return .keychainError
		default:
			return .unknownNSError(self)
		}
	}

	func asFirestoreError() -> FirebaseFirestoreError {
		let firestoreErrorCode = FirestoreErrorCode(_nsError: self)
		switch firestoreErrorCode.code {
		case .cancelled:
			return .cancelled
		case .unknown:
			return .unknownNSError(self)
		case .invalidArgument:
			return .invalidArgument
		case .deadlineExceeded:
			return .deadlineExceeded
		case .notFound:
			return .notFound
		case .alreadyExists:
			return .alreadyExists
		case .permissionDenied:
			return .permissionDenied
		case .resourceExhausted:
			return .resourceExhausted
		case .failedPrecondition:
			return .failedPrecondition
		case .aborted:
			return .aborted
		case .outOfRange:
			return .outOfRange
		case .unimplemented:
			return .unimplemented
		case .internal:
			return .internalError
		case .unavailable:
			return .unavailable
		case .dataLoss:
			return .dataLoss
		case .unauthenticated:
			return .unauthenticated
		default:
			return .unknownNSError(self)
		}
	}

	func asFirebaseStorageError() -> FirebaseStorageError {
		if let storageErrorCode = StorageErrorCode(rawValue: self.code) {
			switch storageErrorCode {
			case .retryLimitExceeded:
				return .retryLimitExceeded
			case .bucketNotFound:
				return .bucketNotFound
			case .objectNotFound:
				return .objectNotFound
			case .quotaExceeded:
				return .quotaExceeded
			case .unauthorized:
				return .unauthorized
			default:
				return .unknownStorageError(storageErrorCode)
			}
		} else {
			return .unknownNSError(self)
		}
	}
}
