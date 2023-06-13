//
//  Sample4.swift
//  StickyHeaderSample
//Twitter

import SwiftUI

struct Sample4: View {
    @State var HeaderHeightSize: CGFloat = 0
    @State var HeaderOffsetY: CGFloat = 0
    @State var shiftOffset: CGFloat = 0
    @State var direction: SwipeDirection = .none
    @State var lastHeaderOffset: CGFloat = 0
    @State var scrollPlay: CGFloat = 0

    var statusHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }


    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(1..<10) { _ in
                    Rectangle()
                        .fill(Color.blue.opacity(0.4).gradient)
                        .frame(height: 200)
                        .padding()
                }
            }
            .offsetY { previous, current in
                headerOffset(previous, current)
            }
        }
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
        
        VStack() {
            HStack {
                Image("pic")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)


                Image("Sample4")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(x: -20)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("おすすめ")
                    .overlay(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.blue)
                            .frame(height: 2.5)
                            .offset(y:10)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width/2)

                Text("フォロー中")
                    .foregroundColor(.gray)
                    .frame(maxWidth: UIScreen.main.bounds.width/2)

            }
            .fontWeight(.semibold)
            .font(.system(size: 11))

            Divider()
        }
        .opacity(1 + progress)
        .background(.regularMaterial)
    }

    func headerOffset(_ previous: CGFloat, _ current: CGFloat) {
        guard current < 0 else { return }
        if previous > current {
            if direction != .up {
                direction = .up
                shiftOffset = current
                lastHeaderOffset = HeaderOffsetY
                scrollPlay = 0
            }

            scrollPlay = shiftOffset - current
            print(scrollPlay)
            guard scrollPlay > 80 else { return }

            let offset = current - shiftOffset + lastHeaderOffset + 80
            HeaderOffsetY = -offset < (HeaderHeightSize - statusHeight)  ? offset : (-HeaderHeightSize + statusHeight)

        } else {
            if direction != .down {
                direction = .down
                shiftOffset = current
                lastHeaderOffset = HeaderOffsetY
                scrollPlay = 0
            }

            scrollPlay = -(shiftOffset - current)
            guard scrollPlay > 80 else { return }

            let offset = lastHeaderOffset - (shiftOffset - current + 80)

            HeaderOffsetY = offset < 0 ? offset : 0
        }
    }
}

struct Sample4_Previews: PreviewProvider {
    static var previews: some View {
        Sample4()
    }
}
