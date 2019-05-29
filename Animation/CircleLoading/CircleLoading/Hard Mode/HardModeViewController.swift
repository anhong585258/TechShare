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
        bezierView?.controlPoints = [CGPoint(x: 100, y: 100), CGPoint(x: 200, y: 110), CGPoint(x: 220, y: 300), CGPoint(x: 120, y: 310)]
        bezierView?.draw()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Try", style: .plain, target: self, action: #selector(tapButton(sender:)))
    }
}

class HardModeView: UIView {
    var controlPoints: [CGPoint] = []
    weak var displayLink: CADisplayLink?
    
    private let speed = 0.01
    private var u = 0.01

    var allPoints: [CGPoint] = []
    var finalPoint: CGPoint = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func draw() {
        allPoints.removeAll()
        finalPoint = calculate(points: controlPoints, u: CGFloat(u))
        displayLink?.isPaused = false
    }
    
    @objc private func onDisplay(display: CADisplayLink) {
        allPoints.removeAll()
        u = u + speed
        if u > 1.0 {
            u = 0.01
            displayLink?.isPaused = true
        } else {
            finalPoint = calculate(points: controlPoints, u: CGFloat(u))
            setNeedsDisplay()
        }
    }
    
    private func setup() {
        backgroundColor = .white

        let displayLink = CADisplayLink(target: self, selector: #selector(onDisplay(display:)))
        displayLink.add(to: .main, forMode: .common)
        displayLink.isPaused = true
        self.displayLink = displayLink
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
            let distanceY = second.y - second.y
            let current = CGPoint(x: first.x + distanceX * u, y: first.y + distanceY * u)
            tempPoints.append(current)
            allPoints.append(current)
        }
        
        return calculate(points: tempPoints, u: u)
    }
    
    private func drawLines(points: [CGPoint], color: UIColor = .darkGray) {
        for index in 0..<(points.count - 1) {
            let start = points[index]
            let end = points[index + 1]
            drawPoint(point: start, pointColor: color)
            drawLine(with: start, to: end, color: color)
        }
        if let last = points.last {
            drawPoint(point: last, pointColor: color)
        }
    }
    
    private func drawPoint(point: CGPoint, pointColor: UIColor) {
        
    }
    
    private func drawLine(with start: CGPoint, to end: CGPoint, color: UIColor) {
        
    }
}
