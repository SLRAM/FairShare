//
//  ReceiptModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

struct ReceiptModel: Identifiable, Codable, Hashable {
	var id: UUID
	var creator: UserModel
	var date: Date
	var imageURL: String
	//TODO: update items to [any ReceiptText]
	var items: [ReceiptItem]
	//TODO: add guest IDs to display receipt for all guests as well

	init(id: UUID, creator: UserModel, date: Date, imageURL: String, items: [ReceiptItem]) {
		self.id = id
		self.creator = creator
		self.date = date
		self.imageURL = imageURL
		self.items = items
	}

	static func == (lhs: ReceiptModel, rhs: ReceiptModel) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
		}
}

extension ReceiptModel {
	static let dummyData: ReceiptModel = dummyArrayData[0]
	static let dummyArrayData: [ReceiptModel] = [
		ReceiptModel(
			id: UUID(),
			creator: UserModel.dummyData,
			date: Date(),
			imageURL: "https://picsum.photos/200/300",
			items: ReceiptItem.dummyArrayData
		),
		ReceiptModel(
			id: UUID(),
			creator: UserModel.dummyArrayData[1],
			date: Date(),
			imageURL: "https://picsum.photos/200/300",
			items: ReceiptItem.dummyArrayData
		)
	]
}

protocol ReceiptText: Identifiable, Comparable {
	var id: UUID { get }
	var title: String { get set }

	func toDictionary() -> [String: Any]
}

enum ReceiptItemType: String, CaseIterable, Decodable {
	case item
	case subTotal
	case tax
	case tip
	case total
}

class ReceiptItem: ReceiptText, Identifiable, Codable, Hashable {
	//TODO: add user IDs [String] for people responsible for item. If payerIDs is empty then assume everyone shared the cost. If more than one payerIDs then divide cost by count.
	let id: UUID
	var title: String
	var cost: Double
	var payerIDs: [String]?
	var type: ReceiptItemType

	init(id: UUID = UUID(), title: String, cost: Double, payerIDs: [String] = [], type: ReceiptItemType = .item) {
		self.id = id
		self.title = title
		self.cost = cost
		self.payerIDs = payerIDs
		self.type = type
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
		}

	static func == (lhs: ReceiptItem, rhs: ReceiptItem) -> Bool {
		return lhs.id == rhs.id && lhs.title == rhs.title && lhs.cost == rhs.cost
	}


	static func < (lhs: ReceiptItem, rhs: ReceiptItem) -> Bool {
		return lhs.id < rhs.id
	}

	enum CodingKeys: String, CodingKey {
		case id
		case title
		case cost
		case payerIDs
		case type
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(UUID.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
		cost = try container.decode(Double.self, forKey: .cost)
		payerIDs = try container.decodeIfPresent([String].self, forKey: .payerIDs)
		type = try container.decode(ReceiptItemType.self, forKey: .type)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(cost, forKey: .cost)
		try container.encodeIfPresent(payerIDs, forKey: .payerIDs)
		try container.encode(type.rawValue, forKey: .type)
	}
}

extension ReceiptItem {
	var costAsCurrency: String {
		return String(format: "$%.02f", self.cost)

	}

	func toDictionary() -> [String: Any] {
			return [
				"id": id.uuidString,
				"title": title,
				"cost": cost,
				"type": type.rawValue
			]
		}

	static let dummyData: ReceiptItem = dummyArrayData[0]
	static let dummyArrayData: [ReceiptItem] = [
		ReceiptItem(
			title: "Apple",
			cost: 1.99
		),
		ReceiptItem(
			title: "Banana",
			cost: 0.99
		),
		ReceiptItem(
			title: "Orange",
			cost: 1.49
		),
		ReceiptItem(
			title: "Tax",
			cost: 0.40,
			type: .tax
		),
		ReceiptItem(
			title: "Total",
			cost: 4.87,
			type: .total
		)
	]
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

extension ReceiptInformation {
	func toDictionary() -> [String : Any] {
		return [
			"id": id.uuidString,
			"title": title
		]
	}
}
