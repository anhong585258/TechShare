//
//  HardModeViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/29.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class HardModeViewController: UIViewController {
    @IBOutlet private weak var progressSlider: UISlider!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var bezierView: HardModeView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        navigationItem.title = "我是贝塞尔曲线"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bezierView?.invalid()
    }
    
    @objc private func tapTryButton(sender: UIBarButtonItem) {
        progressSlider.value = 0.0
        progressLabel.text = "0.0"
        bezierView?.draw()
    }
    
    @objc private func tapResetButton(sender: UIBarButtonItem) {
        progressSlider.value = 0.0
        progressLabel.text = "0.0"
        bezierView.reset()
    }
    
    @IBAction func manuProgress(_ sender: UISlider) {
        bezierView.setProgress(progress: sender.value)
        progressLabel.text = String(sender.value)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Try", style: .plain, target: self, action: #selector(tapTryButton(sender:))),
                                              UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(tapResetButton(sender:)))]
        
        progressSlider.minimumValue = 0.0
        progressSlider.maximumValue = 1.0
    }
}
