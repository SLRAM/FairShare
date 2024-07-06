//
//  ReceiptModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

struct ReceiptModel: Identifiable, Codable, Hashable {
	//TODO: creator will not always be the current User. Add ReceiptModel to creator account and to any user listed in guestIDs.
	var id: UUID
	var creator: UserModel
	var date: Date
	var imageURL: String
	var items: [ReceiptItem]
	var guestIDs: [String]

	init(id: UUID, creator: UserModel, date: Date, imageURL: String, items: [ReceiptItem], guestIDs: [String]) {
		self.id = id
		self.creator = creator
		self.date = date
		self.imageURL = imageURL
		self.items = items
		self.guestIDs = guestIDs
	}

	static func == (lhs: ReceiptModel, rhs: ReceiptModel) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension ReceiptModel {
	func currentUserReceipt(userID: String) -> [ReceiptItem] {
		let filteredItems = items.filter { item in
			switch item.type {
			case .item:
				guard let payerIDs = item.payerIDs else {
					return true
				}
				return payerIDs.contains(userID) || payerIDs.isEmpty
			case .subTotal, .tax, .tip, .total:
				return true
			}
		}
		
		return filteredItems
	}

	func userSubtotal(userID: String) -> Double {
		let filteredItems = items.filter { item in
			guard let payerIDs = item.payerIDs else {
				return true
			}

			return item.type == .item &&
			(payerIDs.contains(userID) || payerIDs.isEmpty)
		}

		let totalItemsCost = filteredItems.reduce(0.0) { (result, item) -> Double in
			return result + item.costPerPayer(guestCount: guestIDs.count)
		}

		return totalItemsCost.roundToDecimal(2)
	}

	func userTaxTotal(userID: String) -> Double {
		let value = userSubtotal(userID: userID) * (calculatedTaxPercentage() / 100.0)
		return value.roundToDecimal(2)
	}

	func userTotal(userID: String) -> Double {
		return userSubtotal(userID: userID) + userTaxTotal(userID: userID)
	}

	func calculatedTaxPercentage() -> Double {
		let subtotal = items.first(where: { $0.type == .subTotal })?.cost
		let tax = items.first(where: { $0.type == .tax })?.cost

		guard let subtotal = subtotal, subtotal > 0 else {
			print("Error: Subtotal must be greater than zero.")
			return 0.0
		}

		guard let tax = tax, tax > 0 else {
			print("Error: Subtotal must be greater than zero.")
			return 0.0
		}

		let taxPercentage = (tax / subtotal) * 100
		return taxPercentage
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
			items: ReceiptItem.dummyArrayData, 
			guestIDs: UserModel.dummyArrayData.map { $0.id }
		),
		ReceiptModel(
			id: UUID(),
			creator: UserModel.dummyArrayData[1],
			date: Date(),
			imageURL: "https://picsum.photos/200/300",
			items: ReceiptItem.dummyArrayData, 
			guestIDs: UserModel.dummyArrayData.map { $0.id }
		)
	]
}
