//
//  ReceiptModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

struct ReceiptModel: Identifiable, Codable {
	var id: UUID
	var creator: UserModel
	var date: Date
	var imageURL: String
	//TODO: add guest IDs to display receipt for all guests as well

	init(id: UUID, creator: UserModel, date: Date, imageURL: String) {
		self.id = id
		self.creator = creator
		self.date = date
		self.imageURL = imageURL
	}

	static let dummyData: ReceiptModel = ReceiptModel(id: UUID(), creator: UserModel.dummyData, date: Date(), imageURL: "https://picsum.photos/200/300")
}

protocol ReceiptText: Identifiable, Comparable {
	var id: UUID { get }
	var title: String { get set }
}

class ReceiptItem: ReceiptText {
	//TODO: add user IDs [String] for people responsible for item
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
