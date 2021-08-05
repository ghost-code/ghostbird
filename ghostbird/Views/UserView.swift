//
//  UserView.swift
//  UserView
//
//  Created by David Russell on 8/4/21.
//

import SwiftUI

struct UserView: View {

    @ObservedObject var user: User

    var body: some View {
        List {
            Section {
                ForEach(user.tweets) {
                    TweetView(tweet: $0)
                }
            } header: {
                header
                    .font(.body)
                    .foregroundColor(Color("LabelColor"))
            }
        }
        .listStyle(.plain)
        .navigationTitle(user.name)
    }

    var header: some View {
        VStack(alignment: .leading) {
            HStack {
                userImage

                VStack(alignment: .leading) {
                    Text(user.userName)
                    Text("Joined \(user.createdAt.agoString)")
                    if let location = user.location {
                        HStack(spacing: 2) {
                            Image(systemName: "location.fill")
                            Text(location)
                        }
                    }
                }
            }
            Text(user.description)
                .lineLimit(nil)
        }
    }

    var userImage: some View {
        AsyncImage(url: user.profileImageURL) { image in
            image
                .resizable()
                .clipShape(Circle())
        } placeholder: {
            Circle()
                .fill(Color.gray)
        }
        .frame(width: 66, height: 66)
    }
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
