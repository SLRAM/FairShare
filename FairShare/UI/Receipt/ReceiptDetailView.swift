//
//  ReceiptDetailView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/22/24.
//

import SwiftUI

struct ReceiptDetailView: View {
	@ObservedObject var viewModel: ReceiptDetailViewModel

	var body: some View {
		VStack(spacing: 0) {
			Toggle(isOn: $viewModel.isEnabled) {
				Text(viewModel.isEnabled ? Strings.ReceiptDetailView.onToggleTitle.string : Strings.ReceiptDetailView.defaultToggleTitle.string)
					.font(.headline)
			}
			.toggleStyle(SwitchToggleStyle())
			.padding(.horizontal)
			.padding(.bottom, 5)
			.onChange(of: viewModel.isEnabled) {
				viewModel.toggleEnabled()
			}

			GeometryReader { geometry in
				List {
					ForEach(viewModel.displayedGroupedItems, id: \.self) { itemInType in
						Section(header: Text(itemInType[0].type.rawValue)) {
							ForEach(itemInType) { item in
								HStack {
									Text(item.title)
									Spacer()
									Text(viewModel.formattedCost(for: item))
								}
							}
						}
					}

					Section(header: Strings.ReceiptDetailView.imagesSectionTitle.text) {
						HStack {
							Spacer()
							AsyncImage(url: URL(string: viewModel.receipt.imageURL)) { phase in
								switch phase {
								case .empty:
									ProgressView()
								case .success(let image):
									image.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
								case .failure:
									EmptyView()
								@unknown default:
									EmptyView()
								}
							}

							Spacer()
						}
						.frame(height: geometry.size.height * 0.5)
						.background(Color(.systemGray5))
					}
				}
				.listSectionSpacing(0)
				.navigationTitle(viewModel.receipt.date.toString(.full))
				.navigationBarTitleDisplayMode(.inline)
			}
		}
	}
}


#Preview {
	ReceiptDetailView(viewModel: ReceiptDetailViewModel(receipt: ReceiptModel.dummyData, userID: UserModel.dummyData.id))
}
