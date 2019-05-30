//
//  PainterViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/26.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class SomePanGestureRecognizer: UIPanGestureRecognizer {
    private(set) var initialTouchLocation: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first?.location(in: view)
    }
}

class PainterViewController: UIViewController {
    private weak var panGestureRecognizer: UIPanGestureRecognizer?
    private weak var displayLink: CADisplayLink?
    private weak var shapeLayer: CAShapeLayer?
    private var path = UIBezierPath()
    private var previousPoint: CGPoint = .zero
    private var beginPoint: CGPoint = .zero
    private let threadhold: CGFloat = 10.0

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        navigationItem.title = "我是手绘"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        displayLink?.invalidate()
    }
    
    // MARK: - Actions
    @objc private func panGesture(pan: UIPanGestureRecognizer) {
        let currentPoint = pan.location(in: view)
        
        switch pan.state {
        case .began:
            if previousPoint == .zero {
                if let pan  = pan as? SomePanGestureRecognizer {
                    path.move(to: pan.initialTouchLocation ?? currentPoint)
                } else {
                    path.move(to: currentPoint)
                }
                beginPoint = currentPoint
            }
            previousPoint = currentPoint
        case .changed:
            path.addQuadCurve(to: currentPoint, controlPoint: CGPoint(x: (currentPoint.x + previousPoint.x) / 2, y: (currentPoint.y + previousPoint.y) / 2))
            previousPoint = currentPoint
        case .ended:
            previousPoint = .zero
        case .cancelled:
            previousPoint = .zero
        case .failed:
            previousPoint = .zero
        default:
            previousPoint = .zero
        }
    }
    
    @objc private func displayPaint(display: CADisplayLink) {
        shapeLayer?.path = path.cgPath
        shapeLayer?.setNeedsDisplay()
    }

    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .white
        
        panGestureRecognizer = {
//            let pan = SomePanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
            view.addGestureRecognizer(pan)
            return pan
        }()
        
        shapeLayer = {
           let shape = CAShapeLayer()
            view.layer.addSublayer(shape)
            shape.fillColor = nil
            shape.strokeColor = UIColor.blue.cgColor
            shape.lineWidth = 4.0
            shape.lineJoin = .round
            return shape
        }()
        
        displayLink = {
            let display = CADisplayLink(target: self, selector: #selector(displayPaint(display:)))
            display.add(to: .current, forMode: .common)
            return display
        }()
    }
    
    private func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt((pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2)))
    }
}
