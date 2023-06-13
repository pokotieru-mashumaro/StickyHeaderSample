//
//  Sample1.swift
//  StickyHeaderSample
//インスタ

import SwiftUI

struct Sample1: View {
    @State var HeaderHeightSize: CGFloat = 0
    @State var HeaderOffsetY: CGFloat = 0
    @State var shiftOffset: CGFloat = 0 
    @State var direction: SwipeDirection = .none
    @State var lastHeaderOffset: CGFloat = 0

    var statusHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<10, id: \.self) { _ in
                    Rectangle()
                        .fill(.green)
                        .frame(height: 200)
                }
            }
            .padding(.top, HeaderHeightSize + 10)
            .offsetY { previous, current in
                headerOffset(previous, current)
            }
        }
        .coordinateSpace(name: "Sample1")
        .overlay(alignment: .top) {
                HeaderView()
                    .anchorPreference(key: HeaderBoundsKey.self, value: .bounds) { $0 }
                    .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                        GeometryReader { proxy in
                            if let anchor = value {
                                Color.clear
                                    .onAppear {
                                        HeaderHeightSize = proxy[anchor].height + safeArea().top
                                    }
                            }
                        }
                    }
                    .offset(y: HeaderOffsetY + safeArea().top)
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    func HeaderView() -> some View {
        let progress = -(HeaderOffsetY / HeaderHeightSize) > 1 ? -1 : (HeaderOffsetY > 0 ? 0 : (HeaderOffsetY / (HeaderHeightSize - statusHeight)))

        HStack(spacing: 20) {
            HStack(spacing: 0) {
                Image("Sample1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                Image(systemName: "chevron.down").bold()
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "heart")
                .resizable()
                .frame(width: 24, height: 20)

            Image(systemName: "paperplane")
                .resizable()
                .frame(width: 24, height: 24)

        }
        .opacity(1 + progress)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
    }

    func headerOffset(_ previous: CGFloat, _ current: CGFloat) {
        guard current < 0 else { return }
        if previous > current {
            if direction != .up {
                direction = .up
                shiftOffset = current
                lastHeaderOffset = HeaderOffsetY
            }

            let offset = current - shiftOffset + lastHeaderOffset
            HeaderOffsetY = -offset < (HeaderHeightSize - statusHeight)  ? offset : (-HeaderHeightSize + statusHeight)

        } else {
            if direction != .down {
                direction = .down
                shiftOffset = current
                lastHeaderOffset = HeaderOffsetY
            }
            let offset = lastHeaderOffset - (shiftOffset - current)

            HeaderOffsetY = offset < 0 ? offset : 0
        }
    }

}

struct Sample1_Previews: PreviewProvider {
    static var previews: some View {
        Sample1()
    }
}

