//
//  WiredViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/26.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class WiredViewController: UIViewController {
    var name: String?
    weak var delegate: TestDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    @objc private func tapButton(sender: UIButton) {
        delegate?.wantSwitch(senderName: name!)
    }
    
    private func setup() {
        let button: UIButton = UIButton(frame: CGRect(x: 10, y: 50, width: 80, height: 30))
        button.setTitle(".green", for: .normal)
        button.setTitleColor(.green, for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
    }
    
}

protocol TestDelegate: class {
    func wantSwitch(senderName: String)
}

class TestWindow: UIWindow {
    var name: String
    
    class func create(name: String, color: UIColor, delegate: TestDelegate) -> TestWindow {
        let window = TestWindow(name: name)
        window.backgroundColor = .white
        let vc = WiredViewController()
        window.rootViewController = vc
        vc.view.backgroundColor = color
        vc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        vc.name = name
        vc.delegate = delegate
        
        return window
    }
    
    init(name: String) {
        self.name = name
        super.init(frame: CGRect(x: 10, y: 10, width: 300, height: 500))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 非常怪异
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
}
