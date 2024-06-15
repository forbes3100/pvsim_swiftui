//
//  ContentView.swift
//  PVSim_SwiftUI
//
//  Created by Scott Forbes on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var namesImageSize: CGSize = .zero
    @State private var imageSize: CGSize = .zero
    @State private var verticalScrollOffset: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            if imageSize != .zero {
                HStack(spacing: 2) {
                    // Left side with fixed width
                    ScrollViewReader { scrollViewProxy in
                        ScrollView([.vertical], showsIndicators: false) {
                            VStack {
                                Image("test_timing_names")
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(CGSize(width: 0.5, height: 0.5), anchor: .center)
                                    .frame(width: 0.5 * namesImageSize.width,
                                           height: 0.5 * imageSize.height)
                                    .clipped()
                            }
                        }
                        .onAppear {
                            scrollViewProxy.scrollTo(verticalScrollOffset)
                        }
                        .onChange(of: verticalScrollOffset) { newOffset in
                            print("Left ScrollView: newOffset = \(newOffset)")
                            scrollViewProxy.scrollTo(newOffset)
                        }
                    }
                    .background(Color.yellow)

                    // Right side with scroll view
                    ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        ScrollViewReader { scrollViewProxy_R in
                            VStack {
                                Image("test_timing")
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(CGSize(width: 0.5, height: 0.5), anchor: .center)
                                    .frame(
                                        width: 0.5 * imageSize.width,
                                        height: 0.5 * imageSize.height)
                                    .clipped()
                            }
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scrollView")).origin.y)
                            })
                        }
                    }
                    .background(Color.teal)
                    .coordinateSpace(name: "scrollView")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { newOffset in
                        print("onPreferenceChange: newOffset = \(newOffset)")
                        verticalScrollOffset = newOffset
                    }
                }
                .background(Color.gray)
            } else {
                Image("test_timing_names")
                    .background(
                        GeometryReader { imageGeometry in
                            Color.clear
                                .onAppear {
                                    print("test_timing_names init")
                                    self.namesImageSize = imageGeometry.size
                                }
                        }
                    )
                    .hidden()
                Image("test_timing")
                    .background(
                        GeometryReader { imageGeometry in
                            Color.clear
                                .onAppear {
                                    print("test_timing init")
                                    self.imageSize = imageGeometry.size
                                }
                        }
                    )
                    .hidden()
            }
        }
    }
}

// A PreferenceKey is a way to collect some value from child Views for use by parent
// or children. In this case we get the last scrolled position of the timing View, to be used
// by its row-names sibling View.

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
        .frame(width: 800, height: 500)
}
