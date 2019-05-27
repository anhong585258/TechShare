//
//  NavigationBackViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/27.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class NavigationBackViewController: UIViewController {
    // MARK: - Properties
    private weak var topLine: CAShapeLayer?
    private weak var middleLine: CAShapeLayer?
    private weak var bottomLine: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    // MARK: - Actions
    @objc private func tapButton(sender: UIBarButtonItem) {
    }

    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Try", style: .plain, target: self, action: #selector(tapButton(sender:)))

        topLine = line()
        topLine?.position = CGPoint(x: 100, y: 200)
        middleLine = line()
        middleLine?.position = CGPoint(x: 100, y: 240)
        bottomLine = line()
        bottomLine?.position = CGPoint(x: 100, y: 280)
    }
    
    private func line() -> CAShapeLayer {
        let line = CAShapeLayer()
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 10))
        line.path = path.cgPath
        line.fillColor = UIColor.blue.cgColor
        line.strokeColor = UIColor.blue.cgColor
        view.layer.addSublayer(line)
        
        return line
    }
}
