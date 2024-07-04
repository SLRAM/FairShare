//
//  Double+Helper.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 7/7/24.
//

import Foundation

extension Double {
	func currencyFormat() -> String {
		String(format: "$%.02f", self)
	}

	func roundToDecimal(_ fractionDigits: Int) -> Double {
		let multiplier = pow(10, Double(fractionDigits))
		return Darwin.round(self * multiplier) / multiplier
	}
}
