//
//  Image+Helper.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/25/24.
//

import Foundation
import UIKit
import SwiftUI

internal final class ImageAsset {
	internal let type: AssetType = .Images
	internal let name: String
	internal let path: String
	internal let isSystem: Bool


	internal init(name: String, isSystem: Bool = false) {
		self.name = name
		self.path = "\(self.type.rawValue)/\(self.name)"
		self.isSystem = isSystem
	}

	internal private(set) lazy var image = Image(asset: self, isSystem: isSystem)

	internal private(set) lazy var uiImage = UIImage(asset: self, isSystem: isSystem)

	internal private(set) lazy var imageResource = ImageResource(asset: self)
}

extension Image {
	init(asset: ImageAsset, isSystem: Bool) {
		if isSystem {
			self.init(systemName: asset.name)
		} else {
			self.init(asset.path, bundle: Bundle(for: BundleHelper.self))
		}
	}
}

extension UIImage {
	convenience init!(asset: ImageAsset, isSystem: Bool) {
		if isSystem {
			self.init(systemName: asset.name)
		} else {
			self.init(named: asset.path, in: Bundle(for: BundleHelper.self), compatibleWith: nil)
		}
	}
}

extension ImageResource {
	init(asset: ImageAsset) {
		self.init(name: asset.path, bundle: Bundle(for: BundleHelper.self))
	}
}
