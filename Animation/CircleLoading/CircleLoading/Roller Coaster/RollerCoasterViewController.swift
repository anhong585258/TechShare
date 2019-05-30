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
    private var smoothPath: UIBezierPath = UIBezierPath()
    private var points: [CGPoint] = []
    private var previousPoint: CGPoint = .zero
    private weak var trackLayer: CAShapeLayer?
    private var carLayer: CALayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    @IBAction func tapStart(_ sender: UIButton) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = smoothPath.cgPath
        animation.rotationMode = .rotateAuto
        animation.duration = 5
        animation.timingFunction = .init(name: .easeInEaseOut)
        CATransaction.begin()
        carLayer.add(animation, forKey: nil)
        CATransaction.setCompletionBlock {
            CATransaction.setDisableActions(true)
            self.carLayer.position = self.previousPoint
        }
        CATransaction.commit()
    }
    
    @IBAction func tapReset(_ sender: UIButton) {
        points.removeAll()
        bezierPath.removeAllPoints()
        smoothPath.removeAllPoints()
        previousPoint = .zero
        carLayer.removeAllAnimations()
        updateTrack()
    }
    
    @IBAction func tapSmoothConnect(_ sender: UIButton) {
        guard points.count > 1 else { return }
        calculate(points: points, bezier: bezierPath)
        updateTrack()
        previousPoint = points.last ?? .zero
        points = [previousPoint]
        smoothPath.append(bezierPath)
        bezierPath.removeAllPoints()
        bezierPath.move(to: previousPoint)
    }
    
    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: view)
        points.append(point)

        if previousPoint == .zero {
            bezierPath.move(to: point)
        } else {
            bezierPath.addLine(to: point)
        }
        previousPoint = point
        bezierPath.addArc(withCenter: point, radius: 2.0, startAngle: CGFloat(-Float.pi), endAngle: CGFloat(Float.pi), clockwise: true)

        updateTrack()
    }
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        carLayer.contents = UIImage(named: "Car")?.cgImage
        carLayer.frame = CGRect(x: 100, y: 100, width: 40, height: 40)
        view.layer.addSublayer(carLayer)
    }
    
    private func updateTrack() {
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
        let finalPath = UIBezierPath()
        finalPath.append(smoothPath)
        finalPath.append(bezierPath)
        trackLayer?.path = finalPath.cgPath
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
        for u in stride(from: 0.05, to: 1.05, by: 0.05) {
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
