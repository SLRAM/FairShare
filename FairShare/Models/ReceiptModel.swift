//
//  ReceiptModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

struct ReceiptModel: Identifiable {
	var id: String
	var date: String
	var subtotal: Double
	var tax: Double
	var tip: Double
	var total: Double
}

protocol ReceiptText: Identifiable, Comparable {
	var id: UUID { get }
	var title: String { get set }

}

class ReceiptItem: ReceiptText {
	let id: UUID
	var title: String
	var cost: Double

	init(id: UUID = UUID(), title: String, cost: Double) {
		self.id = id
		self.title = title
		self.cost = cost
	}

	var costAsCurrency: String {
		return String(format: "$%.02f", self.cost)

	}

	static func == (lhs: ReceiptItem, rhs: ReceiptItem) -> Bool {
		return lhs.id == rhs.id && lhs.title == rhs.title && lhs.cost == rhs.cost
	}


	static func < (lhs: ReceiptItem, rhs: ReceiptItem) -> Bool {
		return lhs.id < rhs.id
	}
}

class ReceiptInformation: ReceiptText {
	let id: UUID
	var title: String

	init(id: UUID = UUID(), title: String) {
		self.id = id
		self.title = title
	}

	static func == (lhs: ReceiptInformation, rhs: ReceiptInformation) -> Bool {
		return lhs.id == rhs.id && lhs.title == rhs.title
	}

	static func < (lhs: ReceiptInformation, rhs: ReceiptInformation) -> Bool {
		return lhs.id < rhs.id
	}

}
