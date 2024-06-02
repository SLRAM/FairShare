//
//  SettingsRowView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/12/24.
//

import SwiftUI

struct SettingsRowView: View {
	enum RowType {
		case signOut
		case delete

		var image: Image {
			switch self {
			case .signOut:
				return Images.System.arrowLeftCircleFill.image
			case .delete:
				return Images.System.xMarkCircleFill.image
			}
		}

		var title: String {
			switch self {
			case .signOut:
				return Strings.ProfileView.signOut
			case .delete:
				return Strings.ProfileView.delete
			}
		}

		var tintColor: Color {
			switch self {
			case .signOut, .delete:
				return Color.red
			}
		}
	}

	let rowType: RowType

	var body: some View {
		HStack(spacing: 22) {
			rowType.image
				.imageScale(.small)
				.font(.title)
				.foregroundStyle(rowType.tintColor)

			Text(rowType.title)
				.font(.subheadline)
				.foregroundStyle(.black)
		}
	}
}

#Preview {
	SettingsRowView(rowType: .signOut)
}
