//
//  CustomList.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/11/24.
//

import SwiftUI

struct CustomList<Item: Identifiable & Hashable>: View {
	var items: [Item]
	@Binding var selectedIDs: Set<Item.ID>
	var title: (Item) -> String

	var body: some View {
		List {
			ForEach(items, id: \.id) { item in
				HStack {
					Text(title(item))
					Spacer()
					if selectedIDs.contains(item.id) {
						Images.System.checkmarkCircle.image
							.foregroundColor(.green)
					}
				}
				.contentShape(Rectangle())
				.onTapGesture {
					toggleSelection(for: item)
				}
			}
		}
	}

	private func toggleSelection(for item: Item) {
		if selectedIDs.contains(item.id) {
			selectedIDs.remove(item.id)
		} else {
			selectedIDs.insert(item.id)
		}
	}
}


#Preview {
//	SelectableListView(items: <#[_]#>, selectedIDs: <#Binding<Set<_>>#>, displayName: <#(_) -> String#>)
	NontentView()
		.previewLayout(.sizeThatFits)
		.padding()
}

struct Payer: Identifiable, Hashable {
	var id: UUID
	var abbreviatedName: String
}

struct NontentView: View {
	@State private var selectedPayerIDs: Set<UUID> = []

	// Example data
	let availablePayers: [Payer] = [
		Payer(id: UUID(), abbreviatedName: "John"),
		Payer(id: UUID(), abbreviatedName: "Jane"),
		Payer(id: UUID(), abbreviatedName: "Doe")
	]

	var body: some View {
		CustomList(
			items: availablePayers,
			selectedIDs: $selectedPayerIDs,
			title: { $0.abbreviatedName }
		)
		.padding()
	}
}

//struct NontentView_Previews: PreviewProvider {
//	static var previews: some View {
//		NontentView()
//			.previewLayout(.sizeThatFits)
//			.padding()
//	}
//}
