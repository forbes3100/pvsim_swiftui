//
//  ContentView.swift
//  PVSim_SwiftUI
//
//  Created by Scott Forbes on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var imageSize: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                if imageSize != .zero {
                    Image("test_timing")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize.width * 0.5, height: imageSize.height * 0.5)
                } else {
                    Image("test_timing")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(
                            GeometryReader { imageGeometry in
                                Color.clear
                                    .onAppear {
                                        self.imageSize = imageGeometry.size
                                    }
                            }
                        )
                        .hidden()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    ContentView()
}
