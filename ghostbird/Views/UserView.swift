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
            // Tweets / mentions / favorites
            // following / followers
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
        .task {
            if !user.isLoaded {
                await user.getUser()
            }
            if user.tweets.isEmpty {
                await user.getTweets()
            }
        }
        .listStyle(.plain)
        .navigationTitle(user.userName)
    }

    var header: some View {
        VStack(alignment: .leading) {
            HStack {
                userImage

                VStack(alignment: .leading) {
                    Text(user.name ?? "")
                    Text(createdAtString)
                    if let location = user.location {
                        HStack(spacing: 2) {
                            Image(systemName: "location.fill")
                            Text(location)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Text(user.description ?? "")
                .lineLimit(nil)
        }
        .padding(16)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .overlay(Color("SeparatorColor").frame(height: 0.5).ignoresSafeArea(), alignment: .bottom)
    }

    var createdAtString: String {
        if let agoString = user.createdAt?.agoString {
            return "Joined \(agoString)"
        } else {
            return ""
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
