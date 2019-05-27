//
//  CircleViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/26.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    private weak var circleLayer: CAShapeLayer?
    
    private var firstAnimation: CAAnimation {
        let beginTime = 0.5
        let strokeStartDuration = 1.7
        let strokeEndDuration = 1.0
        
        let strokeEndAnimation: CABasicAnimation = {
            $0.keyPath = "strokeEnd"
            $0.duration = strokeEndDuration
            $0.fromValue = 0
            $0.toValue = 1
            $0.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 0.0, 0.18, 1.0)
            return $0
        }(CABasicAnimation())

        let strokeStartAnimation: CABasicAnimation = {
            $0.keyPath = "strokeStart"
            $0.duration = strokeStartDuration
            $0.fromValue = 0
            $0.toValue = 1
            $0.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 0.0, 0.18, 1.0)
            $0.beginTime = beginTime
            return $0
        }(CABasicAnimation())
        
        let groupAnimation:CAAnimationGroup = {
            $0.animations = [strokeEndAnimation, strokeStartAnimation]
            $0.duration = strokeStartDuration + beginTime
            $0.repeatCount = .infinity
            $0.isRemovedOnCompletion = false
            return $0
        }(CAAnimationGroup())
        
        return groupAnimation
    }
    
    private var circleAnimation: CAAnimation {
        let beginTime = 0.5
        let strokeStartDuration = 1.7
        let strokeEndDuration = 1.0

        let strokeEndAnimation: CABasicAnimation = {
            $0.keyPath = "strokeEnd"
            $0.duration = strokeEndDuration
            $0.fromValue = 0
            $0.toValue = 1
            $0.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 0.0, 0.18, 1.0)
            return $0
        }(CABasicAnimation())
        
        let strokeStartAnimation: CABasicAnimation = {
            $0.keyPath = "strokeStart"
            $0.duration = strokeStartDuration
            $0.fromValue = 0
            $0.toValue = 1
            $0.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 0.0, 0.18, 1.0)
            $0.beginTime = beginTime
            return $0
        }(CABasicAnimation())
        
        let rotationAnimation: CABasicAnimation = {
            $0.keyPath = "transform.rotation"
            $0.byValue = Float.pi * 2
            $0.timingFunction = CAMediaTimingFunction(name: .linear)
            return $0
        }(CABasicAnimation())
        
        let groupAnimation:CAAnimationGroup = {
            $0.animations = [strokeEndAnimation, strokeStartAnimation, rotationAnimation]
            $0.duration = strokeStartDuration + beginTime
            $0.repeatCount = .infinity
            $0.isRemovedOnCompletion = false
            return $0
        }(CAAnimationGroup())
        return groupAnimation
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        circleLayer?.position = view.layer.position
    }
    
    // MARK: - Actions
    @objc private func tapSlowButton(sender: UIBarButtonItem) {
        circleLayer?.removeAllAnimations()
        circleLayer?.add(circleAnimation, forKey: "circle")
        circleLayer?.speed = 0.1
    }
    
    @objc private func tapFirstButton(sender: UIBarButtonItem) {
        circleLayer?.removeAllAnimations()
        circleLayer?.add(firstAnimation, forKey: "circle")
        circleLayer?.speed = 1.0
    }
    
    @objc private func tapFinaltButton(sender: UIBarButtonItem) {
        circleLayer?.removeAllAnimations()
        circleLayer?.add(circleAnimation, forKey: "circle")
        circleLayer?.speed = 1.0
    }
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Final", style: .plain, target: self, action: #selector(tapFinaltButton(sender:))),
                                              UIBarButtonItem(title: "First", style: .plain, target: self, action: #selector(tapFirstButton(sender:))),
                                              UIBarButtonItem(title: "Slow", style: .plain, target: self, action: #selector(tapSlowButton(sender:)))]
        
        let size: CGFloat = 200.0
        circleLayer = {
            let layer = CAShapeLayer()
            let path = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: size / 2, startAngle: -(.pi / 2), endAngle: .pi + .pi / 2, clockwise: true)
            layer.fillColor = nil
            layer.lineCap = .round
            layer.strokeColor = UIColor.blue.cgColor
            layer.lineWidth = 14.0
            layer.path = path.cgPath
            layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
            view.layer.addSublayer(layer)
            return layer
        }()
        
        circleLayer?.add(circleAnimation, forKey: "circle")
    }
}
