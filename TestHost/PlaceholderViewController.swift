//
//  PlaceholderViewController.swift
//  TestHost
//
//  Created by vvveiii on 2019/5/8.
//  Copyright © 2019 lvv. All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let textLabel = UILabel()
        textLabel.text = NSLocalizedString("I'm Placeholder", comment: "")
        textLabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ])
    }
}
