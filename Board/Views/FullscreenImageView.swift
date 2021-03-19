//
//  FullscreenImageView.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullscreenImageView: View {
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0

    let url: URL?

    var body: some View {
        VStack {
            Spacer()
            WebImage(url: url)
                .resizable()
                .scaledToFit()
                .cornerRadius(24)
            Spacer()
        }
        .background(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            self.isPresented = false
        }
    }
}

struct ZoomableImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenImageView(isPresented: .constant(true), url: URL(string: "https://source.unsplash.com/featured/500x500/?person"))
    }
}
