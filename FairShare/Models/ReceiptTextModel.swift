//
//  ReceiptTextModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 7/7/24.
//

import Foundation

protocol ReceiptText: Identifiable, Comparable {
	var id: UUID { get }
	var title: String { get set }

	func toDictionary() -> [String: Any]
}
//TODO: Refactor name to account for multiple uses of "Item"
enum ReceiptItemType: String, CaseIterable, Decodable {
	case item
	case subTotal
	case tax
	case tip
	case total
}

class ReceiptItem: ReceiptText, Identifiable, Codable, Hashable {
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
	func costPerPayer(guestCount: Int) -> Double {
		var count = 0

		if let payerIDs = payerIDs, payerIDs.count > 0 {
			count = payerIDs.count
		} else {
			count = guestCount + 1
		}

		let costPerPayer = cost / Double(count)

		return costPerPayer
	}

	func toDictionary() -> [String: Any] {
		var dictionary: [String: Any] = [
			"id": id.uuidString,
			"title": title,
			"cost": cost,
			"type": type.rawValue
		]

		if let payerIDs = payerIDs {
			dictionary["payerIDs"] = payerIDs
		}

		return dictionary
	}
}

extension ReceiptItem {
	static let dummyData: ReceiptItem = dummyArrayData[0]
	static let dummyArrayData: [ReceiptItem] = [
		ReceiptItem(
			title: "Apple",
			cost: 1.99,
			payerIDs: ContactModel.dummyArrayData.map { $0.id }
		),
		ReceiptItem(
			title: "Banana",
			cost: 0.99,
			payerIDs: [ContactModel.dummyData.id]
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
