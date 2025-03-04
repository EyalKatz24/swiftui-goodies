//
//  ShimmerableText.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import Foundation
import SwiftUI

/// Text view with shimmering loadable data within a sentence.
///
/// Use string implicit member function `shimmerText(count:)` where you want the shimmer to appear.
///
/// - NOTE: This view is *NOT* perfect at all and very expensive compared to regular `Text` view.
/// There are some issues with its composition, that's why it is wrapped by `ZStack`, and can't support break lines well.
/// When there is a better solution for implementing that view - please do so 🫶🏼
struct ShimmerableText: View {
    
    nonisolated fileprivate static let shimmerPatternCharacter = "☯︎"
    var text: String
    
    struct Word: Identifiable {
        var id = UUID()
        var value: String
        
        var isShimmer: Bool { value.contains(shimmerPatternCharacter) }
    }
    
    private var words: [Word] {
        text.split(separator: " ").map(String.init).map { word in
            .init(value: word)
        }
    }
    
    var body: some View {
        ZStack {
            FlowLayout {
                ForEach(words) { word in
                    if word.isShimmer {
                        Text(word.value)
                            .opacity(0)
                            .overlay {
                                Shimmer(shape: .rect(cornerRadius: 4))
                                    .padding(.vertical, 2)
                            }
                            .accessibilityHidden(true)
                    } else {
                        Text(word.value)
                    }
                    
                    Text(" ")
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}

struct FlowLayout: Layout {
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var totalHeight: CGFloat = .zero
        var totalWidth: CGFloat = .zero
        var lineWidth: CGFloat = .zero
        var lineHeight: CGFloat = .zero
        
        for size in sizes {
            if lineWidth + size.width > proposal.width ?? .zero {
                totalHeight += lineHeight
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width
                lineHeight = max(lineHeight, size.height)
            }
            
            totalWidth = max(totalWidth, lineWidth)
        }
        
        totalHeight += lineHeight
        
        return .init(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = .zero
        
        for index in subviews.indices {
            if lineX + sizes[index].width > (proposal.width ?? .zero) {
                lineY += lineHeight
                lineHeight = .zero
                lineX = bounds.minX
            }
            
            subviews[index].place(
                at: .init(
                    x: lineX + sizes[index].width / 2,
                    y: lineY + sizes[index].height / 2
                ),
                anchor: .center,
                proposal: ProposedViewSize(sizes[index])
            )
            
            lineHeight = max(lineHeight, sizes[index].height)
            lineX += sizes[index].width
        }
    }
}

extension String {
    
    /// Used to create a "text" covered by shimmer in `ShimmerableText`.
    ///
    /// - parameter count: The amount of characters to replace by shimmer.
    /// - returns: A string that would be replaced by a shimmer in `ShimmerableText`.
    @MainActor static func shimmerText(count: Int) -> String {
        guard count > 0 else { return "" }
        let shimmerText = String(repeating: ShimmerableText.shimmerPatternCharacter, count: count)
        return " \(shimmerText) "
    }
}
