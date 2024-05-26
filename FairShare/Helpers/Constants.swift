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
	}
}

enum ConstantStrings {
	enum LoginView {
	}

	enum MainTabView {
	}

	enum ReceiptView {
	}

	enum ProfileView {
	}
}
