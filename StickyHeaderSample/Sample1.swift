//
//  Sample1.swift
//  StickyHeaderSample
//

import SwiftUI

struct Sample1: View {
    @State var HeaderHeightSize: CGFloat = 0 // MARK: headerの高さ +safeエリアの高さ
    @State var HeaderOffsetY: CGFloat = 0 //直接使うやつ
    @State var shiftOffset: CGFloat = 0 //offsetをキープ
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
        let progress = -(HeaderOffsetY / (HeaderHeightSize - 80)) > 1 ? -1 : (HeaderOffsetY > 0 ? 0 : (HeaderOffsetY / (HeaderHeightSize - 80)))

        HStack(spacing: 30) {
            Circle()
                .fill(.yellow)
                .frame(width: 40, height: 40)

            Text("サンプル1").bold()
                .font(.title)
        }
        .opacity(1 + progress)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple)
    }

    func headerOffset(_ previous: CGFloat, _ current: CGFloat) {
        guard current < 0 else { return } //　上スクロールの上限
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

