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

		var imageName: String {
			switch self {
			case .signOut:
				return "arrow.left.circle.fill"
			case .delete:
				return "xmark.circle.fill"
			}
		}

		var title: String {
			switch self {
			case .signOut:
				return "Sign out"
			case .delete:
				return "Delete account"
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
			Image(systemName: rowType.imageName)
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
