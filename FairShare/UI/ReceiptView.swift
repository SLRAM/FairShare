//
//  ReceiptView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI
import Firebase

struct ReceiptView: View {
	@EnvironmentObject var viewModel: AuthViewModel

	var body: some View {
		NavigationStack {
			List(viewModel.receipts, id: \.id) { receipt in
				Text(receipt.date)
			}
			.navigationTitle("Previous Receipts")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Menu {
						Button(action: {}, label: {
							Text("Take a photo")
						})
						Button(action: {}, label: {
							Text("Add from library")
						})
					} label: {
						Label(title: { Text("Label") }, icon: { Image(systemName: "plus") })
					}
				}
			}
		}
	}
}

#Preview {
	ReceiptView().environmentObject(AuthViewModel())
}
