//
//  BasicViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/6/1.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    private weak var ballLayer: CALayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    // MARK: - Actions
    @objc private func tapBegin(sender: UIButton) {
        ballLayer?.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        let randomColor: () -> CGColor = {
            let r = CGFloat(arc4random() % 55) / 255.0
            let g = CGFloat(arc4random() % 255) / 255.0
            let b = CGFloat(arc4random() % 255) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: 1.0).cgColor
        }
        animation.toValue = randomColor()
        animation.duration = 2.0
        ballLayer?.add(animation, forKey: nil)
    }

    @objc private func tapReset(sender: UIButton) {
        ballLayer?.backgroundColor = UIColor.red.cgColor
    }
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Begin", style: .plain, target: self, action: #selector(tapBegin(sender:))),
                                              UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(tapReset(sender:)))]
        navigationItem.title = "我是隐式动画"
        
        ballLayer = {
            $0.backgroundColor = UIColor.red.cgColor
            $0.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
            $0.cornerRadius = 100
            $0.masksToBounds = true
            view.layer.addSublayer($0)
            return $0
        }(CALayer())
    }
}

// MARK: - CAAnimationDelegate
extension BasicViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag, let animation = anim as? CABasicAnimation else { return }
        if let toValue = animation.toValue {
            ballLayer?.backgroundColor = (toValue as! CGColor)
        }
    }
}
