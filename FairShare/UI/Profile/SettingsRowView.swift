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
		case contacts

		var image: Image {
			switch self {
			case .signOut:
				return Images.System.arrowLeftCircleFill.image
			case .delete:
				return Images.System.xMarkCircleFill.image
			case .contacts:
				return Images.System.listBulletCircleFill.image
			}
		}

		var title: String {
			switch self {
			case .signOut:
				return Strings.ProfileView.signOut
			case .delete:
				return Strings.ProfileView.delete
			case .contacts:
				return Strings.ProfileView.addContacts
			}
		}

		var tintColor: Color {
			switch self {
			case .signOut, .delete:
				return Color.red
			case .contacts:
				return Color.green
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
