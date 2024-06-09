//
//  Date+Helper.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

extension Date {
	enum DateFormatType: String {
		case full = "MMMM dd hh:mm a"
		case standard = "MMMM dd"
	}

	static func getISOTimestamp() -> String {
		let isoDateFormatter = ISO8601DateFormatter()
		let timestamp = isoDateFormatter.string(from: Date())
		return timestamp
	}

	func toString(format: DateFormatType = .standard) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format.rawValue
		return dateFormatter.string(from: self)
	}

	func adding(minutes: Int) -> Date {
		return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
	}
}
