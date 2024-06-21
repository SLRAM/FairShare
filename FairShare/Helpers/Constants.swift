//
//  Constants.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/25/24.
//

import Foundation
import UIKit
import SwiftUI

///TODO convert to macro

enum AssetType: String {
	case Images
	case Colors
	case Text
}

final class BundleHelper { }

internal final class TextAsset {
	internal let type: AssetType = .Text
	let string: String

	internal init(string: String) {
		self.string = string
	}

	internal private(set) lazy var text = Text(string)

}

struct Colors {
}

struct Images {
	struct System {
		static let arrowLeftCircleFill = ImageAsset(name: "arrow.left.circle.fill", isSystem: true)
		static let arrowRight = ImageAsset(name: "arrow.right", isSystem: true)
		static let listDash = ImageAsset(name: "list.dash", isSystem: true)
		static let personCropCircle = ImageAsset(name: "person.crop.circle", isSystem: true)
		static let plus = ImageAsset(name: "plus", isSystem: true)
		static let xMarkCircleFill = ImageAsset(name: "xmark.circle.fill", isSystem: true)
	}
}

struct Strings {
	struct LoginView {
		static let confirmString = "OK"
		static let welcome = "Welcome Back"
		static let register = "Register"
		static let signIn = "Sign in"
		static let signUp = "Sign up"
		static let doesNotHaveAccount = "Don't have an account? "
		static let hasAccount = "Already have an account? "

		static let emailPlaceholder = "email@example.com"
		static let passwordPlaceholder = "Enter your password"
		static let namePlaceholder = "Enter your "

		static let firstName = "First Name"
		static let LastName = "Last Name"
		static let email = "Email Address"
		static let password = "Password"
		static let confirmPassword = "Confirm Password"
	}

	struct MainTabView {
		static let receiptsTab = TextAsset(string: "Receipts")
		static let profileTab = TextAsset(string: "Profile")
	}

	struct NewReceiptView {
		static let navigationTitle = TextAsset(string: "New Receipt")
		static let editButton = TextAsset(string: "Edit")
		static let saveButton = TextAsset(string: "Save")

		static let cameraButton = "Camera"
		static let galleryButton = "Photo Gallery"
		static let cancelButton = "Cancel"

		static let confirmationMessage = TextAsset(string: "Take a new photo or select one from the photo gallery")
	}

	struct ProfileView {
		static let account = "Account"
		static let delete = "Delete Account"
		static let signOut = "Sign Out"
	}

	struct ReceiptCardView {
		static let dateTitle = TextAsset(string: "Date:")
		static let creatorTitle = TextAsset(string: "Created by:")
	}

	struct ReceiptView {
		static let navigationTitle = TextAsset(string: "Receipt History")
		static let emptyState = TextAsset(string: "Click the + to add a new receipt")
	}
}

struct Constants {
	static let ProfileImagePath = "profileImages/"
	static let ReceiptImagePath = "receiptImages/"
	static let StorageContentType = "image/jpg"

	struct UserCollectionKeys {
		static let CollectionKey = "users"
		static let UserIdKey = "userId"
		static let FirstNameKey = "firstName"
		static let LastNameKey = "lastName"
		static let EmailKey = "email"
		static let PhotoURLKey = "photoURL"
	}

	struct ReceiptCollectionKeys {
		static let CollectionKey = "receipts"
		static let DocumentIdKey = "id"
		static let CreatorIDKey = "creatorID"
		static let DateKey = "date"
		static let ImageURLKey = "imageURL"
	}

	struct StorageKeys {
		static let ImagesKey = "images"
	}
}
