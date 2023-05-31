//
//  Sample2Component.swift
//  StickyHeaderSample
//

import SwiftUI

struct Sample2OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetY(coodinateSpace: CoordinateSpace, completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: coodinateSpace).minY

                    Color.clear
                        .preference(key: Sample2OffsetKey.self, value: minY)
                        .onPreferenceChange(Sample2OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}
