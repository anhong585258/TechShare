//
//  ThreeBallView.swift
//  CircleLoading
//
//  Created by jhunter on 2019/5/29.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class ThreeBallView: UIView {
    
    static var estimatedSize:CGSize {
        return CGSize(width: edge * 2 + radius * 6 + distance * 2, height: edge * 2 + radius * 2)
    }
    
    // MARK: - Private properties
    private weak var leftBallLayer: CALayer!
    private weak var middleBallLayer: CALayer!
    private weak var rightBallLayer: CALayer!
    private let leftColor = UIColor(red: 33.0 / 255.0, green: 198.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0).cgColor
    private let middleColor = UIColor(red: 33.0 / 255.0, green: 198.0 / 255.0, blue: 55.0 / 255.0, alpha: 0.7).cgColor
    private let rightColor = UIColor(red: 33.0 / 255.0, green: 198.0 / 255.0, blue: 55.0 / 255.0, alpha: 0.4).cgColor

    private var leftPosition: CGPoint {
        return CGPoint(x: (leftBallLayer.position.x + middleBallLayer.position.x) / 2.0, y: leftBallLayer.position.y)
    }
    private var rightPosition: CGPoint {
        return CGPoint(x: (rightBallLayer.position.x + middleBallLayer.position.x) / 2.0, y: rightBallLayer.position.y)
    }
    private let duration = 1.1
    

    private static let radius = 5.0
    private static let distance = 20.0
    private static let edge = 20.0
    
    private var leftAnimation: CAAnimation {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        path.addArc(withCenter: leftPosition, radius: CGFloat(ThreeBallView.distance / 2.0), startAngle: CGFloat(-Float.pi), endAngle: 0.0, clockwise: true)
        let path2 = UIBezierPath()
        path2.addArc(withCenter: rightPosition, radius: CGFloat(ThreeBallView.distance / 2.0), startAngle: CGFloat(-Float.pi), endAngle: 0.0, clockwise: false)
        path.append(path2)
        positionAnimation.duration = duration
        positionAnimation.timingFunction = .init(name: .easeInEaseOut)
        positionAnimation.path = path.cgPath
        positionAnimation.repeatCount = Float.infinity
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = duration
        colorAnimation.timingFunction = .init(name: .easeInEaseOut)
        colorAnimation.repeatCount = Float.infinity
        colorAnimation.fromValue = leftColor
        colorAnimation.toValue = middleColor
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [positionAnimation, colorAnimation]
        group.repeatCount = Float.infinity

        return group
    }

    private var middleAnimation: CAAnimation {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        path.addArc(withCenter: leftPosition, radius: CGFloat(ThreeBallView.distance / 2.0), startAngle: 0.0, endAngle: CGFloat(-Float.pi), clockwise: true)
        positionAnimation.duration = duration
        positionAnimation.timingFunction = .init(name: .easeInEaseOut)
        positionAnimation.path = path.cgPath
        positionAnimation.repeatCount = Float.infinity
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = duration
        colorAnimation.timingFunction = .init(name: .easeInEaseOut)
        colorAnimation.repeatCount = Float.infinity
        colorAnimation.fromValue = middleColor
        colorAnimation.toValue = leftColor
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [positionAnimation, colorAnimation]
        group.repeatCount = Float.infinity
        
        return group
    }

    private var rightAnimation: CAAnimation {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        path.addArc(withCenter: rightPosition, radius: CGFloat(ThreeBallView.distance / 2.0), startAngle: 0.0, endAngle: CGFloat(-Float.pi), clockwise: false)
        positionAnimation.duration = duration
        positionAnimation.timingFunction = .init(name: .easeInEaseOut)
        positionAnimation.path = path.cgPath
        positionAnimation.repeatCount = Float.infinity
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = duration
        colorAnimation.timingFunction = .init(name: .easeInEaseOut)
        colorAnimation.repeatCount = Float.infinity
        colorAnimation.fromValue = rightColor
        colorAnimation.toValue = middleColor
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [positionAnimation, colorAnimation]
        group.repeatCount = Float.infinity

        return group
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func startLeftAnimation() {
        leftBallLayer.timeOffset = 0
        leftBallLayer.speed = 1.0
    }
    
    func startMiddleAnimation() {
        middleBallLayer.speed = 1.0
        middleBallLayer.timeOffset = 0
    }
    
    func startRightAnimation() {
        rightBallLayer.speed = 1.0;
        rightBallLayer.timeOffset = 0
    }
    
    func start() {
        startLeftAnimation()
        startMiddleAnimation()
        startRightAnimation()
    }
    
    func stop() {
        leftBallLayer.speed = 0
        leftBallLayer.timeOffset = 0
        middleBallLayer.speed = 0
        middleBallLayer.timeOffset = 0
        rightBallLayer.speed = 0;
        rightBallLayer.timeOffset = 0
    }

    // MARK: - Private methods
    private func setup() {
        setupLayer()
//        setupMeasureLayer()
        initializeAnimations()
    }
    
    private func setupLayer() {
        leftBallLayer = {
            let layer = CALayer()
            layer.bounds = CGRect(x: 0, y: 0, width: ThreeBallView.radius * 2, height: ThreeBallView.radius * 2)
            layer.backgroundColor = leftColor
            layer.cornerRadius = CGFloat(ThreeBallView.radius)
            layer.masksToBounds = true
            self.layer.addSublayer(layer)
            return layer
        }()
        leftBallLayer.frame = CGRect(x: ThreeBallView.edge, y: ThreeBallView.edge, width: ThreeBallView.radius * 2.0, height: ThreeBallView.radius * 2.0)
        
        middleBallLayer = {
            let layer = CALayer()
            layer.bounds = CGRect(x: 0, y: 0, width: ThreeBallView.radius * 2, height: ThreeBallView.radius * 2)
            layer.backgroundColor = middleColor
            layer.cornerRadius = CGFloat(ThreeBallView.radius)
            layer.masksToBounds = true
            self.layer.addSublayer(layer)
            return layer
        }()
        middleBallLayer.frame = CGRect(x: ThreeBallView.edge + ThreeBallView.distance, y: ThreeBallView.edge, width: ThreeBallView.radius * 2.0, height: ThreeBallView.radius * 2.0)
        
        rightBallLayer = {
            let layer = CALayer()
            layer.bounds = CGRect(x: 0, y: 0, width: ThreeBallView.radius * 2, height: ThreeBallView.radius * 2)
            layer.backgroundColor = rightColor
            layer.cornerRadius = CGFloat(ThreeBallView.radius)
            layer.masksToBounds = true
            self.layer.addSublayer(layer)
            return layer
        }()
        rightBallLayer.frame = CGRect(x: ThreeBallView.edge + ThreeBallView.distance + ThreeBallView.distance, y: ThreeBallView.edge, width: ThreeBallView.radius * 2.0, height: ThreeBallView.radius * 2.0)
    }
    
    private func setupMeasureLayer() {
        var measureLayer = CALayer()
        measureLayer.frame = CGRect(x: Double(leftBallLayer.position.x) + ThreeBallView.radius,
                                    y: Double(leftBallLayer.position.y) + ThreeBallView.radius,
                                    width: Double(middleBallLayer.position.x) - ThreeBallView.radius - ThreeBallView.radius - Double(leftBallLayer.position.x),
                                    height: 10)
        measureLayer.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(measureLayer)
        measureLayer = CALayer()
        measureLayer.frame = CGRect(x: Double(middleBallLayer.position.x) + ThreeBallView.radius,
                                    y: Double(middleBallLayer.position.y) + ThreeBallView.radius,
                                    width: Double(rightBallLayer.position.x) - ThreeBallView.radius - ThreeBallView.radius - Double(middleBallLayer.position.x),
                                    height: 10)
        measureLayer.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(measureLayer)
    }

    private func initializeAnimations() {
        leftBallLayer.speed = 0.0
        leftBallLayer.add(leftAnimation, forKey: nil)
        leftBallLayer.timeOffset = 0

        middleBallLayer.speed = 0.0
        middleBallLayer.add(middleAnimation, forKey: nil)
        middleBallLayer.timeOffset = 0

        rightBallLayer.speed = 0.0
        rightBallLayer.add(rightAnimation, forKey: nil)
        rightBallLayer.timeOffset = 0
    }
}
