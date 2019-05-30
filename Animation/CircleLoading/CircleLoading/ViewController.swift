//
//  ViewController.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/23.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

enum AnimationListTableViewItemIndex: Int {
    case circleLoading = 0
    case bezierDraw = 1
    case threeBall = 2
    case metaBall = 3
    case DeCasteljau = 4
    case rollerCoaster = 5
    
    var title: String {
        switch self {
        case .circleLoading:
            return "Spin loading"
        case .bezierDraw:
            return "Draw via pan"
        case .threeBall:
            return "Three ball loading"
        case .metaBall:
            return "Meta Ball"
        case .DeCasteljau:
            return "Hard模式"
        case .rollerCoaster:
            return "Roller Coaster"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .circleLoading:
            return .darkText
        case .bezierDraw:
            return .darkText
        case .threeBall:
            return .darkText
        case .metaBall:
            return .lightGray
        case .DeCasteljau:
            return .darkText
        case .rollerCoaster:
            return .lightGray
        }
    }
    
    var viewController: UIViewController? {
        switch self {
        case .circleLoading:
            return CircleViewController()
        case .bezierDraw:
            return PainterViewController()
        case .threeBall:
            return ThreeBallViewController()
        case .metaBall:
            return nil
        case .DeCasteljau:
            let story = UIStoryboard(name: "Main", bundle: .main)
            return story.instantiateViewController(withIdentifier: "HardModeViewController")
        case .rollerCoaster:
            return RollerCoasterViewController()
        }
    }

    static var count: Int { return 6 }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let reuseCellId = "reusecell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "我是一个动画Demo"
    }
    
    // MARK: - Actions
    
    // MARK: - Private methods
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimationListTableViewItemIndex.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath)
        let item = AnimationListTableViewItemIndex(rawValue: indexPath.row)
        cell.textLabel?.text = item?.title
        cell.textLabel?.textColor = item?.titleColor
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = AnimationListTableViewItemIndex(rawValue: indexPath.row)
        if let vc = item?.viewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
