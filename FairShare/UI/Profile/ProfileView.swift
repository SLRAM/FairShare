//
//  ProfileView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI

struct ProfileView: View {
	@EnvironmentObject var viewModel: AuthViewModel
	var body: some View {
		if let user = viewModel.currentUser {
			List {
				Section {
					HStack {
						Text(user.initials)
							.font(.title)
							.fontWeight(.semibold)
							.foregroundStyle(.white)
							.frame(width: 72, height: 72)
							.background(Color(.systemGray3))
							.clipShape(Circle())

						VStack(alignment: .leading, spacing: 5) {
							Text(user.fullName)
								.font(.subheadline)
								.fontWeight(.semibold)
								.padding(.top, 5)

							Text(user.email)
								.font(.footnote)
								.foregroundStyle(.gray)
						}
					}
				}

				Section(ConstantStrings.ProfileView.account) {
					Button {
						viewModel.signOut()
					} label: {
						SettingsRowView(rowType: .signOut)
					}

					Button {
						print(ConstantStrings.ProfileView.delete)
					} label: {
						SettingsRowView(rowType: .delete)
					}
				}
			}
		}
	}
}

#Preview {
	ProfileView().environmentObject(AuthViewModel())
}
