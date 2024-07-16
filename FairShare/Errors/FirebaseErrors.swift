//
//  FirebaseErrors.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/12/24.
//

import Foundation
import Firebase
import FirebaseStorage

protocol FirebaseError: Error, LocalizedError {

}

enum FirebaseAuthError: FirebaseError {
	case emailAlreadyInUse
	case userNotFound
	case userDisabled
	case invalidEmail
	case networkError
	case weakPassword
	case wrongPassword
	case operationNotAllowed
	case keychainError
	case unknownNSError(NSError)
	case unknownError(Error)


	init(_ error: Error) {
		if let nsError = error as NSError? {
			self = nsError.asFirebaseAuthError()
		} else {
			self = .unknownError(error)
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
		case .keychainError:
			return "An error occurred while trying to access secure information. Please try again or contact support if the problem persists."
		case .unknownError(let error):
			return "Unknown Error occurred. Error: \(error)"
		case .unknownNSError(let error):
			return "Unknown NSError occurred. Error code: \(error.code)"
		}
	}
}

enum FirebaseFirestoreError: FirebaseError {
	case cancelled
	case invalidArgument
	case deadlineExceeded
	case notFound
	case alreadyExists
	case permissionDenied
	case resourceExhausted
	case failedPrecondition
	case aborted
	case outOfRange
	case unimplemented
	case internalError
	case unavailable
	case dataLoss
	case unauthenticated
	case unknownError(Error)
	case unknownNSError(NSError)

	init(_ error: Error) {
		if let nsError = error as NSError? {
			self = nsError.asFirestoreError()
		} else {
			self = .unknownError(error)
		}
	}

	var message: String {
		switch self {
		case .cancelled:
			return "Operation was cancelled."
		case .invalidArgument:
			return "Invalid argument provided."
		case .deadlineExceeded:
			return "Deadline for operation exceeded."
		case .notFound:
			return "Requested document was not found."
		case .alreadyExists:
			return "Document already exists."
		case .permissionDenied:
			return "Permission denied."
		case .resourceExhausted:
			return "Resource exhausted."
		case .failedPrecondition:
			return "Failed precondition."
		case .aborted:
			return "Operation aborted."
		case .outOfRange:
			return "Operation out of range."
		case .unimplemented:
			return "Operation not implemented."
		case .internalError:
			return "Internal error occurred."
		case .unavailable:
			return "Service unavailable."
		case .dataLoss:
			return "Data loss or corruption."
		case .unauthenticated:
			return "Unauthenticated request."
		case .unknownError(let error):
			return "Unknown Error occurred. Error: \(error)"
		case .unknownNSError(let error):
			return "Unknown NSError occurred. Error code: \(error.code)"
		}
	}
}

enum FirebaseStorageError: FirebaseError {
	case objectNotFound
	case bucketNotFound
	case projectNotFound
	case quotaExceeded
	case unauthenticated
	case unauthorized
	case retryLimitExceeded
	case nonMatchingChecksum
	case downloadSizeExceeded
	case cancelled
	case invalidArgument
	case unknownError(Error)
	case unknownNSError(NSError)
	case unknownStorageError(StorageErrorCode)

	init(_ error: Error) {
		if let nsError = error as NSError? {
			self = nsError.asFirebaseStorageError()
		} else {
			self = .unknownError(error)
		}
	}

	var errorMessage: String {
		switch self {
		case .retryLimitExceeded:
			return "The operation has failed after retrying multiple times. Please try again later."
		case .bucketNotFound:
			return "The specified bucket could not be found. Please check your configuration."
		case .objectNotFound:
			return "The specified object could not be found. Please check the object name."
		case .quotaExceeded:
			return "The quota for Firebase Storage has been exceeded. Please try again later."
		case .unauthorized:
			return "You are not authorized to perform this operation. Please check your permissions."
		case .projectNotFound:
			return "The specified project could not be found. Please check your project ID and configuration."
		case .unauthenticated:
			return "You are not authenticated. Please log in and try again."
		case .nonMatchingChecksum:
			return "The checksums do not match. The data might be corrupted. Please try again."
		case .downloadSizeExceeded:
			return "The download size exceeds the allowed limit. Please try downloading a smaller file."
		case .cancelled:
			return "The operation was cancelled. Please try again if needed."
		case .invalidArgument:
			return "An invalid argument was provided. Please check the inputs and try again."
		case .unknownNSError(let error):
			return "An unknown NSError occurred. Error code: \(error.code)"
		case .unknownStorageError(let error):
			return "An unknown StorageError occurred. Error: \(error)"
		case .unknownError(let error):
			return "An unknown error occurred. Error: \(error)"
		}
	}
}


enum ImageProcessingError: FirebaseError {
	case imageDataConversionFailed

	var errorMessage: String {
		switch self {
		case .imageDataConversionFailed:
			return "Failed to convert the image data."
		}
	}
}
