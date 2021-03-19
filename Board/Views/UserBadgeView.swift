//
//  UserBadgeView.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserBadgeView: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    let user: User

    private var imageSize: CGFloat {
        sizeClass == .compact ? 48 : 80
    }

    var body: some View {
        HStack {
            WebImage(url: user.photoUrl)
                .resizable()
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.4), radius: 1.5, y: 2.0)
                .frame(width: imageSize, height: imageSize)
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.body)
            }
        }
    }
}

struct UserBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserBadgeView(
                user: User(
                    name: "Dr. Darwin Zemlak",
                    email: "stacy61@hotmail.com",
                    photoUrl: URL(string: "https://source.unsplash.com/user/erondu")!
                )
            )

            UserBadgeView(
                user: User(
                    name: "Dr. Darwin Zemlak",
                    email: "stacy61@hotmail.com",
                    photoUrl: URL(string: "https://source.unsplash.com/featured/500x500/?person")!
                )
            )
            .previewDevice("iPad Air (4th generation)")
        }
        .previewLayout(.sizeThatFits)
    }
}
