//
//  ProfileView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI

struct ProfileView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@EnvironmentObject var viewModel: AuthViewModel
	@State private var selectedContacts: [ContactModel] = []

	var body: some View {
		NavigationView {
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

					Section(Strings.ProfileView.account) {
						Button {
							Task {
								try await viewModel.signOut()
							}
						} label: {
							SettingsRowView(rowType: .signOut)
						}

						Button {
							print(Strings.ProfileView.delete)
						} label: {
							SettingsRowView(rowType: .delete)
						}
					}

					Section(Strings.ProfileView.contacts) {
						NavigationLink(destination: ContactListView(listType: .profile)
							.environment(\.managedObjectContext, viewContext)) {
								SettingsRowView(rowType: .contacts)
							}
					}
				}
			}
		}
	}
}

#Preview {
	ProfileView().environmentObject(AuthViewModel())
}
