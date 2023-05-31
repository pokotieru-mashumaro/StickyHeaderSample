//
//  Sample1Component.swift
//  StickyHeaderSample
//

import SwiftUI

enum SwipeDirection {
    case up
    case down
    case none
}

struct HeaderBoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>?

    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}

struct Sample1OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
struct OffsetHelper: ViewModifier {
    var onChange: (CGFloat, CGFloat) -> ()
    @State var currentOffset: CGFloat = 0
    @State var previousOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .named("Sample1")).minY

                    Color.clear
                        .preference(key: Sample1OffsetKey.self, value: minY)
                        .onPreferenceChange(Sample1OffsetKey.self) { value in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset, currentOffset)
                        }
                }
            }
    }
}

extension View {
    @ViewBuilder
    func offsetY(completions: @escaping (CGFloat, CGFloat) -> ()) -> some View {
        self
            .modifier(OffsetHelper(onChange: completions))
    }

    func safeArea() -> UIEdgeInsets {
          guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
          guard let safeArea = scene.windows.first?.safeAreaInsets else { return .zero }
          return safeArea
      }
}
