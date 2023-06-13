//
//  Sample3.swift
//  StickyHeaderSample
//アマゾン

import SwiftUI

struct Sample3: View {
    @State var offsetY: CGFloat = 0
    @State var HeaderHeightSize: CGFloat = 0

    @State var text: String = ""

    let headerColor = LinearGradient(colors: [Color("Sample3_1"), Color("Sample3_2")], startPoint: .leading, endPoint: .trailing)

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HeaderView()
                        .background(headerColor)
                        .offset(y: offsetY)

                    ForEach(0..<10, id: \.self) { _ in
                        Rectangle()
                            .fill(.green)
                            .frame(height: 200)
                    }
                }
                .padding(.top, HeaderHeightSize)
                .offsetY(coodinateSpace: .named("Sample3")) { offset in
                    if offset > 0 {
                        offsetY = -offset
                    }
                }
            }
            .coordinateSpace(name: "Sample3")

            VStack(spacing:0) {
                SearchBar()
                    .background(headerColor)
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
            }
            .padding(.top, safeArea().top)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    func SearchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")

            TextField("検索", text: $text)

            Spacer()

            Image(systemName: "qrcode.viewfinder")
                .foregroundColor(.gray)

            Image(systemName: "mic")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(Color.white)
        .cornerRadius(8)
        .padding()
        .shadow(radius: 8)
    }

    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 30) {
            Text("サンプル")
            Text("サンプル")
            Text("サンプル")
        }
        .font(.caption)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Sample3_Previews: PreviewProvider {
    static var previews: some View {
        Sample3()
    }
}
