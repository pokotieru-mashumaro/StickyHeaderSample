//
//  Sample2.swift
//  StickyHeaderSample
//

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
            VStack {
                HeaderView()
                    .offset(y: -offsetY)
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
        VStack(spacing: 10) {
            HStack {
                Circle()
                    .fill(.yellow)
                    .frame(width: 40, height: 40)

                Text("サンプル2").bold()
                    .font(.title)
            }
        }
        .padding([.horizontal, .bottom])
        .padding(.top, safeArea().top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple)
    }
}

struct Sample2_Previews: PreviewProvider {
    static var previews: some View {
        Sample2()
    }
}
