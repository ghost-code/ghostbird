//
//  TweetView.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import SwiftUI

struct TweetView: View {

    @ObservedObject var tweet: Tweet

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack {
                userImage
            }
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text(tweet.author.name)
                        .font(.caption)
                        .bold()
                        .lineLimit(1)
                    Text("@" + tweet.author.userName)
                        .font(.caption2)
                        .lineLimit(1)

                    Spacer()

                    Text(tweet.date.agoString)
                        .font(.caption2)
                        .lineLimit(1)
                        .fixedSize()
                }
                Text(tweet.text)
                    .font(.caption)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(4)
    }

    var userImage: some View {
        AsyncImage(url: tweet.author.imageURL) { image in
            image
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        } placeholder: {
            Circle()
                .fill(Color.gray)
                .frame(width: 32, height: 32)
        }
    }
}

//struct TweetView_Previews: PreviewProvider {
//    static var previews: some View {
//        let url = URL(string: "http://s3.amazonaws.com/pix.iemoji.com/images/emoji/apple/ios-12/256/mouse-face.png")!
//        let text = "This is a test a test a test a test a test a test a test a test a test a test a test a test"
//        let tweet = Tweet(tweetDataObject: .init(id: "1", text: text, author_id: "1", conversation_id: "1"),
//                          userDataObject: .init(profile_image_url: url, id: "1", username: "username", name: "THE NAME"))
//        TweetView(tweet: tweet)
//            .previewLayout(.sizeThatFits)
//    }
//}