//
//  HardModeView.swift
//  CircleLoading
//
//  Created by jhunter on 2019/5/30.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class HardModeView: UIView {
    private var controlPoints: [CGPoint] = []
    private weak var displayLink: CADisplayLink?
    
    private var allPoints: [[CGPoint]] = []
    private var finalPoints: [CGPoint] = []
    private var colors: [UIColor] = []
    private let speed = 0.005
    private var u = 0.005

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        
        let displayLink = CADisplayLink(target: self, selector: #selector(onDisplay(display:)))
        displayLink.add(to: .main, forMode: .common)
        displayLink.isPaused = true
        self.displayLink = displayLink
        
        colors = [.red, .green, .blue, .yellow, .orange, .brown, .cyan, .magenta]
        let randomColor: () -> UIColor = {
            let r = CGFloat(arc4random() % 255) / 255.0
            let g = CGFloat(arc4random() % 255) / 255.0
            let b = CGFloat(arc4random() % 255) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
        for _ in 0...9 {
            colors.append(randomColor())
        }
    }
    
    private func calculate(points: [CGPoint], u: CGFloat) -> CGPoint {
        guard points.count > 1 else {
            return points[0]
        }
        
        var tempPoints: [CGPoint] = []
        for index in 0..<(points.count - 1) {
            let first = points[index]
            let second = points[index + 1]
            
            let distanceX = second.x - first.x
            let distanceY = second.y - first.y
            let current = CGPoint(x: first.x + distanceX * u, y: first.y + distanceY * u)
            tempPoints.append(current)
        }
        allPoints.append(tempPoints)
        
        return calculate(points: tempPoints, u: u)
    }
    
}

// MARK: - Event
extension HardModeView {
    // MARK: - Ovderride
    override func draw(_ rect: CGRect) {
        if controlPoints.count > 1, let context = UIGraphicsGetCurrentContext() {
            if displayLink?.isPaused ?? true {
                
            } else {
                for points in allPoints {
                    drawLines(points: points, color: nil, context: context)
                }
            }
            drawLines(points: finalPoints, color: .blue, context: context, wantDrawPoint: false)
            drawLines(points: controlPoints, color: .darkGray, context: context)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard displayLink?.isPaused ?? false,
            let touch = touches.first,
            let context = UIGraphicsGetCurrentContext() else { return }
        
        let point = touch.location(in: self)
        controlPoints.append(point)
        drawPoint(point: point, pointColor: .darkGray, context: context)
    }
    
    // MARK: - Display Link
    @objc private func onDisplay(display: CADisplayLink) {
        allPoints.removeAll()
        u = u + speed
        if u > 1.0 {
            u = 0.005
            displayLink?.isPaused = true
            setNeedsDisplay()
        } else {
            finalPoints.append(calculate(points: controlPoints, u: CGFloat(u)))
            setNeedsDisplay()
        }
    }
    
}

// MARK: - Draw about
extension HardModeView {
    
    func draw() {
        u = 0.01
        allPoints.removeAll()
        finalPoints = [calculate(points: controlPoints, u: CGFloat(u))]
        displayLink?.isPaused = false
    }
    
    func reset() {
        allPoints.removeAll()
        controlPoints.removeAll()
        displayLink?.isPaused = false
    }
    
    func invalid() {
        displayLink?.invalidate()
    }
    
    private func drawLines(points: [CGPoint], color: UIColor?, context: CGContext, wantDrawPoint: Bool = true) {
        var drawColor: UIColor = .blue
        for index in 0..<(points.count - 1) {
            let start = points[index]
            let end = points[index + 1]
            drawColor = color ?? peekColor(index)
            if wantDrawPoint {
                drawPoint(point: start, pointColor: drawColor, context: context)
            }
            drawLine(with: start, to: end, color: drawColor, context: context)
        }
        if let last = points.last {
            if wantDrawPoint {
                drawPoint(point: last, pointColor: drawColor, context: context)
            }
        }
    }
    
    private func drawPoint(point: CGPoint, pointColor: UIColor, context: CGContext) {
        let path = UIBezierPath(arcCenter: point, radius: 3, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        context.addPath(path.cgPath)
        context.setFillColor(pointColor.cgColor)
        context.fillPath()
    }
    
    private func drawLine(with start: CGPoint, to end: CGPoint, color: UIColor, context: CGContext) {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(2.0)
        context.addPath(path)
        context.strokePath()
    }
    
    private func peekColor(_ index: Int) -> UIColor {
        return colors[index % colors.count]
    }
}
