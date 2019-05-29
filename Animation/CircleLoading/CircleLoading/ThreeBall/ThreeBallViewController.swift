//
//  ThreeBallViewController.swift
//  CircleLoading
//
//  Created by jhunter on 2019/5/29.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

class ThreeBallViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "button")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1 : 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Left ball"
            case 1:
                cell.textLabel?.text = "Middle ball"
            case 2:
                cell.textLabel?.text = "Right ball"
            case 3:
                cell.textLabel?.text = "Final"
            default:
                cell.textLabel?.text = "Stop"
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 400 : 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }
        switch indexPath.row {
        case 0:
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
                cell.leftAnimation()
            }
        case 1:
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
                cell.middleAnimation()
            }
        case 2:
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
                cell.rightAnimation()
            }
        case 3:
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
                cell.finalAnimation()
            }
        default:
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
                cell.stop()
            }
        }
    }
    
}

class TableViewCell: UITableViewCell {
    private weak var threeBallView: ThreeBallView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func leftAnimation() {
        threeBallView.startLeftAnimation()
    }
    
    func middleAnimation() {
        threeBallView.startMiddleAnimation()
    }
    
    func rightAnimation() {
        threeBallView.startRightAnimation()
    }
    
    func finalAnimation() {
        threeBallView.start()
    }

    func stop() {
        threeBallView.stop()
    }
    
    private func setup() {
        threeBallView = {
            let view = ThreeBallView(frame: CGRect(origin: .zero, size: ThreeBallView.estimatedSize))
            contentView.addSubview(view)
            return view
        }()
        
        threeBallView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: threeBallView!, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: threeBallView!, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: threeBallView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ThreeBallView.estimatedSize.width)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: threeBallView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ThreeBallView.estimatedSize.height)
        contentView.addConstraint(constraint)
    }
}
