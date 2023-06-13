//
//  Sample2.swift
//  StickyHeaderSample
//スラック

import SwiftUI

struct Sample2: View {
    @State var offsetY: CGFloat = 0

    var statusHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            let progress = -(offsetY / 60) > 1 ? 1 : (offsetY > 0 ? 0 : -(offsetY / 60))

            VStack {
                HeaderView()
                    .offset(y: -offsetY)
                    .zIndex(2)

                Text("別の会話へ移動")
                    .lineLimit(1)
                    .font(.system(size: 17 * (1 - progress)))
                    .foregroundColor(.gray)
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.gray.opacity(0.6), lineWidth: 1.2)
                    )
                    .padding(10)
                    .padding(.horizontal, 120 * progress)
                    .zIndex(1)


                ForEach(0..<10, id: \.self) { _ in
                    Rectangle()
                        .fill(.green)
                        .frame(height: 200)
                }
            }
            .offsetY(coodinateSpace: .named("Sample2")) { offset in
                offsetY = offset
            }
        }
        .coordinateSpace(name: "Sample2")
        .ignoresSafeArea()
    }

    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image("pic")
                .resizable()
                .frame(width: 26, height: 26)
                .scaledToFit()
                .cornerRadius(6)

            Text("布団ちゃんグループ")
                .fontWeight(.black)

            Spacer()

            Image(systemName: "line.3.horizontal.decrease")
                .resizable()
                .fontWeight(.heavy)
                .frame(width: 12, height: 8)

        }
        .foregroundColor(.white)
        .padding(.leading)
        .padding(.trailing, 26)
        .padding(.bottom, 6)
        .padding(.top, safeArea().top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("Sample2"))
    }
}

struct Sample2_Previews: PreviewProvider {
    static var previews: some View {
        Sample2()
    }
}
