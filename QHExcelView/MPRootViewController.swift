//
//  MPRootViewController.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/7/3.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class MPRootViewController: UIViewController {

    @IBOutlet weak var contentView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.dataSource = self
        self.contentView.delegate = self
        // Do any additional setup after loading the view.
    }

}

extension MPRootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "没有锁定"
        case 1:
            cell.textLabel?.text = "锁定第一个cell"
        case 2:
            cell.textLabel?.text = "锁定行"
        case 3:
            cell.textLabel?.text = "锁定列"
        case 4:
            cell.textLabel?.text = "锁定行和列"
        default:
            break
        }
        
        return cell
    }
}

extension MPRootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let config = MPExcelConfig()
        
        switch indexPath.row {
        case 0:
            config.lockStyle = .none
        case 1:
            config.lockStyle = .firstCell
        case 2:
            config.lockStyle = .row([1])
        case 3:
            config.lockStyle = .columns([1])
        case 4:
            config.lockStyle = .both([1], [1])
        default:
            break
        }
        
        let next = ViewController()
        next.configs = config
        self.navigationController?.pushViewController(next, animated: true)
    }
}
