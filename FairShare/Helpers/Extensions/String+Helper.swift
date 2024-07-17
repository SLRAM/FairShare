//
//  String+Helper.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 7/14/24.
//

import Foundation
import UIKit

extension String {
//https://stackoverflow.com/questions/51100121/how-to-generate-an-uiimage-from-custom-text-in-swift
	/// Generates a `UIImage` instance from this string using a specified
	/// attributes and size.
	///
	/// - Parameters:
	///     - attributes: to draw this string with. Default is `nil`.
	///     - size: of the image to return.
	/// - Returns: a `UIImage` instance from this string using a specified
	/// attributes and size, or `nil` if the operation fails.
	func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
		let size = size ?? (self as NSString).size(withAttributes: attributes)
		return UIGraphicsImageRenderer(size: size)
			.image { _ in
				(self as NSString)
					.draw(
						in: CGRect(origin: CGPoint(x: 5, y: 0), size: size),
						withAttributes: attributes
					)
			}
	}

}
