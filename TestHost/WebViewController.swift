//
//  WebViewController.swift
//  TestHost
//
//  Created by vvveiii on 2019/5/8.
//  Copyright © 2019 lvv. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var urlString: String?

    private var webView: WKWebView = WKWebView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
            ])

        if urlString != nil {
            webView.load(URLRequest(url: URL(string: urlString!)!))
        }
    }
}
