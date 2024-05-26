//
//  Color+Helper.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/25/24.
//

import Foundation
import UIKit
import SwiftUI

internal final class ColorAsset {
	internal let type: AssetType = .Colors
	internal let name: String
	internal let path: String

	internal init(name: String) {
		self.name = name
		self.path = "\(self.type.rawValue)/\(self.name)"
	}

	internal private(set) lazy var color = Color(asset: self)

	internal private(set) lazy var uiColor = UIColor(asset: self)!
}

extension Color {
	init(asset: ColorAsset) {
		self.init(asset.path, bundle: Bundle(for: BundleHelper.self))
	}
}

extension UIColor {
	convenience init!(asset: ColorAsset) {
		self.init(named: asset.path, in: Bundle(for: BundleHelper.self), compatibleWith: nil)
	}
}
