//
//  UserView.swift
//  UserView
//
//  Created by David Russell on 8/4/21.
//

import SwiftUI

struct UserView: View {

    enum ListType: String, Identifiable, CaseIterable {
        var id: String { self.rawValue }
        case tweets = "Tweets"
        case mentions = "Mentions"

        var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    }

    @ObservedObject var user: User

    @State var selectedList: ListType = .tweets


    var body: some View {
        List {
            header
                .font(.body)
                .foregroundColor(Color("LabelColor"))
            Section {
                switch selectedList {
                case .tweets:
                    ForEach(user.tweets) {
                        TweetView(tweet: $0)
                    }
                case .mentions:
                    ForEach(user.mentions) {
                        TweetView(tweet: $0)
                    }
                }
            } header: {
                Picker("Timeline List Picker", selection: $selectedList) {
                    ForEach(ListType.allCases) {
                        Text($0.localizedName).tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .onAppear {
            Task {
                if !user.isLoaded {
                    await user.getUser()
                }
                if user.tweets.isEmpty {
                    await user.getTweets()
                }
            }
        }
        .onChange(of: selectedList, perform: {
            if $0 == .mentions, user.mentions.isEmpty {
                Task { await user.getMentions() }
            }
        })
        .listStyle(.plain)
        .navigationTitle("@" + user.username)
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
