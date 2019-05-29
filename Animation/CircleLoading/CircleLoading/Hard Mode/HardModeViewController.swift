//
//  HardModeViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/29.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class HardModeViewController: UIViewController {
    private weak var bezierView: HardModeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bezierView?.displayLink?.invalidate()
    }
    
    @objc private func tapButton(sender: UIBarButtonItem) {
//        bezierView?.controlPoints = [CGPoint(x: 100, y: 200), CGPoint(x: 200, y: 210), CGPoint(x: 220, y: 400), CGPoint(x: 120, y: 410), CGPoint(x: 70, y: 380), CGPoint(x: 30, y: 300)]
        bezierView?.controlPoints = [CGPoint(x: 100, y: 200), CGPoint(x: 200, y: 210), CGPoint(x: 90, y: 470), CGPoint(x: 170, y: 490)]
        bezierView?.draw()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Try", style: .plain, target: self, action: #selector(tapButton(sender:)))
        
        bezierView = {
            let bezierView = HardModeView(frame: view.bounds)
            bezierView.backgroundColor = .white
            view.addSubview(bezierView)
            return bezierView
        }()
    }
}

class HardModeView: UIView {
    var controlPoints: [CGPoint] = []
    weak var displayLink: CADisplayLink?
    
    private let speed = 0.01
    private var u = 0.01

    var allPoints: [CGPoint] = []
    var finalPoints: [CGPoint] = []
    private var colors: [UIColor] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        if controlPoints.count > 1, let context = UIGraphicsGetCurrentContext() {
            drawLines(points: allPoints, color: nil, context: context)
            drawLines(points: finalPoints, color: .blue, context: context)
            drawLines(points: controlPoints, color: .darkGray, context: context)
        }
    }
    
    func draw() {
        u = 0.01
        allPoints.removeAll()
        finalPoints = [calculate(points: controlPoints, u: CGFloat(u))]
        displayLink?.isPaused = false
    }
    
    @objc private func onDisplay(display: CADisplayLink) {
        allPoints.removeAll()
        u = u + speed
        if u > 1.0 {
            u = 0.01
            displayLink?.isPaused = true
        } else {
            finalPoints.append(calculate(points: controlPoints, u: CGFloat(u)))
            setNeedsDisplay()
        }
    }
    
    private func setup() {
        backgroundColor = .white

        let displayLink = CADisplayLink(target: self, selector: #selector(onDisplay(display:)))
        displayLink.add(to: .main, forMode: .common)
        displayLink.isPaused = true
        self.displayLink = displayLink
        
        let randomColor: () -> UIColor = {
            let r = CGFloat(arc4random() % 255) / 255.0
            let g = CGFloat(arc4random() % 255) / 255.0
            let b = CGFloat(arc4random() % 255) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
        for _ in 0...7 {
            colors.append(randomColor())
        }
    }
    
    private func calculate(points: [CGPoint], u: CGFloat) -> CGPoint {
        guard points.count > 1 else {
            allPoints.append(points[0])
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
            allPoints.append(current)
        }
        
        return calculate(points: tempPoints, u: u)
    }
    
    private func drawLines(points: [CGPoint], color: UIColor?, context: CGContext) {
        var drawColor: UIColor = .blue
        for index in 0..<(points.count - 1) {
            let start = points[index]
            let end = points[index + 1]
            drawColor = color ?? peekColor(index)
            drawPoint(point: start, pointColor: drawColor, context: context)
            drawLine(with: start, to: end, color: drawColor, context: context)
        }
        if let last = points.last {
            drawPoint(point: last, pointColor: drawColor, context: context)
        }
    }
    
    private func drawPoint(point: CGPoint, pointColor: UIColor, context: CGContext) {
        let path = CGMutablePath()
        path.move(to: point)
        context.addArc(center: point, radius: 5, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        context.setFillColor(pointColor.cgColor)
        context.addPath(path)
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
