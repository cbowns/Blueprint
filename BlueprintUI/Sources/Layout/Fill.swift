//
//  Fill.swift
//  BlueprintUI
//
//  Created by Kyle Van Essen on 7/9/20.
//

import UIKit


/// An element which wraps a child element, and takes up all the available space vended to it by its
/// parent element. Use this when you want an element to take up all the space it possibly can during a layout pass.
///
public struct Fill : Element {
    
    public var wrapped : Element
    
    public var axes : Axes
    
    init(along axes : Axes = .both, wrapping : Element) {
        self.axes = axes
        self.wrapped = wrapping
    }
    
    // MARK: Element
    
    public var content: ElementContent {
        ElementContent(child: self.wrapped, layout: Layout(axes: self.axes))
    }
    
    public func backingViewDescription(bounds: CGRect, subtreeExtent: CGRect?) -> ViewDescription? {
        nil
    }
    
    private struct Layout : SingleChildLayout {
        
        var axes : Axes
        
        func layout(size: CGSize, child: Measurable) -> LayoutAttributes {
            LayoutAttributes(size: size)
        }
        func measure(in constraint: SizeConstraint, child: Measurable) -> CGSize {
            constraint.maximum
        }
    }
}


public extension Fill {
    
    enum Axes : Equatable {
        case horizontal
        case vertical
        case both
        
        func measure(in constraint: SizeConstraint, child: Measurable) -> CGSize {
            switch self {
            case .horizontal:
                let size = child.measure(in: constraint)
                return CGSize(width: constraint.width.maximum, height: size.height)
                
            case .vertical:
                let size = child.measure(in: constraint)
                return CGSize(width: size.width, height: constraint.height.maximum)
                
            case .both:
                return constraint.maximum
            }
        }
    }
}


public extension Element {
    
    /// Wrap the element in a `Fill` element, so that it will take up the maximum space it is allowed to
    // during layout and measurement passes.
    func fill(along axes : Fill.Axes = .both) -> Fill {
        Fill(along: axes, wrapping: self)
    }
}
