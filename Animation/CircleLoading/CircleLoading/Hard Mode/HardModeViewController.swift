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
        bezierView?.invalid()
    }
    
    @objc private func tapTryButton(sender: UIBarButtonItem) {
        bezierView?.draw()
    }
    
    @objc private func tapResetButton(sender: UIBarButtonItem) {
        bezierView?.reset()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Try", style: .plain, target: self, action: #selector(tapTryButton(sender:))),
                                              UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(tapResetButton(sender:)))]
        
        bezierView = {
            let bezierView = HardModeView(frame: view.bounds)
            bezierView.backgroundColor = .white
            view.addSubview(bezierView)
            return bezierView
        }()
    }
}
