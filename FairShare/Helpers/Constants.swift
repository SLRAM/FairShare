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

enum ConstantColors {
}

enum ConstantImages {
	enum System {
		static let arrowRight = ImageAsset(name: "arrow.right", isSystem: true)
	}
}

enum ConstantStrings {
	enum LoginView {
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

	enum MainTabView {
	}

	enum ReceiptView {
	}

	enum ProfileView {
	}
}
