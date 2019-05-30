//
//  RollerCoasterViewController.swift
//  CircleLoading
//
//  Created by jhunter on 2019/5/30.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class RollerCoasterViewController: UIViewController {
    private var bezierPath: UIBezierPath = UIBezierPath()
    private var points: [CGPoint] = []
    private var previousPoint: CGPoint = .zero
    private weak var trackLayer: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    @IBAction func tapStart(_ sender: UIButton) {
    }
    
    @IBAction func tapReset(_ sender: UIButton) {
        points.removeAll()
        bezierPath.removeAllPoints()
        updataTrack()
    }
    
    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: view)
        points.append(point)
        if points.count == 1 {
            bezierPath.move(to: point)
        } else if points.count == 2 {
            bezierPath.addLine(to: point)
        }
        previousPoint = point
        bezierPath.addArc(withCenter: point, radius: 2.0, startAngle: CGFloat(-Float.pi), endAngle: CGFloat(Float.pi), clockwise: true)
        if points.count > 2 {
            calculate(points: points, bezier: bezierPath)
        }
        updataTrack()
    }
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updataTrack() {
        if trackLayer == nil {
            trackLayer = {
                $0.strokeColor = UIColor.blue.cgColor
                $0.fillColor = UIColor.clear.cgColor
                $0.lineCap = .round
                $0.lineWidth = 3.0
                $0.lineJoin = .round
                view.layer.addSublayer($0)
                return $0
            }(CAShapeLayer())
        }
        trackLayer?.path = bezierPath.cgPath
    }
}

// MARK: - Calculate
extension RollerCoasterViewController {
    private func calculate(points: [CGPoint], bezier: UIBezierPath) {
        bezier.removeAllPoints()
        guard let firstPoint = points.first else {
            return
        }
        bezier.move(to: firstPoint)
        for u in stride(from: 0.05, to: 1.0, by: 0.05) {
            let point = calculate(points: points, u: CGFloat(u))
            bezier.addLine(to: point)
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
        
        return calculate(points: tempPoints, u: u)
    }

}
