//
//  MBBSlider.swift
//  MBBPlayer
//
//  Created by minbaba on 2017/7/25.
//  Copyright © 2017年 minbaba. All rights reserved.
//

import UIKit


@IBDesignable
class MBBSlider: UIControl {


    // MARK: - static property
    fileprivate static let sliderHeight: CGFloat = 10.0
    fileprivate static let barHeight: CGFloat = 4.0
    fileprivate static let touchLimit = 20.0


    // MARK: - property
    @IBInspectable var maxColor: UIColor = UIColor()
    @IBInspectable var minColor: UIColor = UIColor()
    @IBInspectable var barBackgroudColor: UIColor = UIColor()

    var shoudTouchChangeValue: Bool = false  ///< 是否允许修改值

    @IBInspectable var value: Float = 0 {
        didSet {
            value = min(1, max(0, value))
            setNeedsDisplay()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: MBBSlider.sliderHeight)
    }
    
    
    // MARK initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = MBBSlider.sliderHeight / 2
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = MBBSlider.sliderHeight / 2
        clipsToBounds = true
    }
    
}


// MARK: - touch
extension MBBSlider {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let x = Double((touches.first?.location(in: self).x) ?? 0)
        shoudTouchChangeValue = fabs(x - Double(self.value * Float(self.bounds.width))) < MBBSlider.touchLimit
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shoudTouchChangeValue && isEnabled {
            self.value = Float(touches.first?.location(in: self).x ?? 0) / Float(self.bounds.width)
            
            // commit event
            sendActions(for: UIControlEvents.valueChanged)
        }
    }
}

// MARK: - draw
extension MBBSlider {
    override func draw(_ rect: CGRect) {
    
    
        let context = UIGraphicsGetCurrentContext()
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [minColor.cgColor, maxColor.cgColor] as CFArray, locations: [0, 1])!
        
        //// rect declarations
        var valueRect = CGRect(x: 0,
                               y: (MBBSlider.sliderHeight - MBBSlider.barHeight) / 2,
                           width: bounds.width,
                          height: MBBSlider.barHeight)
        
        // draw bg
        context?.saveGState()
        var rectanglePath = UIBezierPath(roundedRect: valueRect, cornerRadius: MBBSlider.barHeight / 2)
        barBackgroudColor.setFill()
        rectanglePath.fill()
        
        // draw gradient
        valueRect.size.width *= CGFloat(value)
        rectanglePath = UIBezierPath(roundedRect: valueRect, cornerRadius: MBBSlider.barHeight / 2)
        rectanglePath.addClip()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint(x: valueRect.minX - 15, y: valueRect.maxY + 1),
                                    end: CGPoint(x: valueRect.maxX + 15, y: valueRect.minY - 1),
                                    options: [CGGradientDrawingOptions.drawsBeforeStartLocation, CGGradientDrawingOptions.drawsAfterEndLocation])
        context?.restoreGState()
    }
}
