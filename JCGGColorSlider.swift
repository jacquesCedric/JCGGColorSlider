//
//  JCGGSliderCell.swift
//
//  Created by Jacob Gold on 19/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//  MIT license
//

import Cocoa


@IBDesignable public class JCGGColorSlider: NSSlider {
    var barBackgroundColor: NSColor = NSColor.darkGray
    
    public var barGradient: NSGradient = NSGradient.init(colors: [NSColor.systemBlue])!
    // Rainbow example
    // var barGradient = NSGradient.init(colors: Array(0...10).map{ NSColor.init(calibratedHue: CGFloat($0) / 10, saturation: 1.0, brightness: 1.0, alpha: 1.0) })!
    
    // Can't do complex gradients with inspectable, so this will do.
    @IBInspectable public var barColor: NSColor {
        set(newValue) {
            barGradient = NSGradient.init(colors: [newValue])!
            self.needsDisplay = true
        }
        get {
            return barGradient.interpolatedColor(atLocation: 1.0)
        }
    }
    
    // The color of the knob
    public var knobColor: NSColor = NSColor.white
    
    // Should the knob color relate to its position on the slider
    fileprivate var _knobColorFromLocation: Bool = true
    @IBInspectable public var knobColorFromLocation: Bool {
        set(newValue) {
            _knobColorFromLocation = newValue
        }
        get {
            return _knobColorFromLocation
        }
    }
    
    // Determines the margins on the bar component.
    public let bezelMargin: CGFloat = 8
    
    
    override public func draw(_ dirtyRect: NSRect) {
        if (self.isVertical) {
            print("JCGGColorSlider - Vertical sliders not yet supported!")
        }
        
        // Bar styling
        barBackgroundColor.setFill()
        let bezelFrame = bounds.insetBy(dx: bezelMargin / 2, dy: bezelMargin)
        let bar = NSBezierPath(roundedRect: bezelFrame, xRadius: bezelFrame.height * 0.5, yRadius: bezelFrame.height * 0.5)
        bar.fill()
        barGradient.draw(in: bar, angle: 0.0)
        
        let innerRect = bounds.insetBy(dx: bounds.height / 2, dy: 0)
        
        // Knob config
        let knobX: CGFloat
        if maxValue - minValue == 0 {
            knobX = innerRect.minX
        } else {
            knobX = innerRect.minX + CGFloat((doubleValue - minValue) / maxValue) * innerRect.width
        }
        
        // Knob shadow
        let shadowPath = NSBezierPath(ovalIn: NSRect(x: (knobX - bounds.height * 0.5), y: 0, width: bounds.height, height: bounds.height).insetBy(dx: 1.5, dy: 1.0))
        NSColor.init(white: 0.3, alpha: 0.3).setFill()
        shadowPath.fill()
        
        // Knob iteself
        let knobPath = NSBezierPath(ovalIn: NSRect(x: knobX - bounds.height * 0.5, y: 0, width: bounds.height, height: bounds.height).insetBy(dx: 2, dy: 2))
        knobColor.setFill()
        knobPath.fill()
        
        // Knob color from location, if enabled
        if (_knobColorFromLocation) {
            let amount:CGFloat = CGFloat(floatValue / Float(maxValue))
            knobColor = barGradient.interpolatedColor(atLocation: amount)
            knobColor.setFill()
            knobPath.fill()
        }
    }
}
