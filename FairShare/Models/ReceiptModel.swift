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
