//
//  SFSplitViewController.swift
//  SFSplitViewController
//
//  Created by vvveiii on 2019/5/8.
//  Copyright © 2019 lvv. All rights reserved.
//

import UIKit

public class SFSplitViewController : UISplitViewController {
    @objc open var masterViewController: UINavigationController? = nil
    @objc open var detailViewController: UINavigationController? = nil
    @objc open var placeholderViewControllerClass: AnyClass = UIViewController.self

    private var isPortrait: Bool {
        get {
#if targetEnvironment(macCatalyst)
            return false
#else
            if traitCollection.horizontalSizeClass == .regular &&
                traitCollection.verticalSizeClass == .regular {
                if view.bounds.width > view.bounds.height {
                    return false
                }

                return true
            }

            if traitCollection.horizontalSizeClass == .regular {
                return false
            }

            return true
#endif
        }
    }

    // disable delegate
    public override var delegate: UISplitViewControllerDelegate? {
        get {
            return self
        }

        set {
            super.delegate = self
        }
    }

    @objc public init(master: UINavigationController, detail: UINavigationController) {
        super.init(nibName: nil, bundle: nil)

        masterViewController = master
        detailViewController = detail
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        guard masterViewController != nil, detailViewController != nil else {
            return
        }

        if detailViewController?.viewControllers.count == 0 {
            let placeholderViewController = (placeholderViewControllerClass as? UIViewController.Type)?.init() ?? UIViewController()
            detailViewController?.viewControllers = [placeholderViewController]
        }

        viewControllers = [masterViewController, detailViewController] as! [UIViewController]

        delegate = self;
        preferredDisplayMode = .allVisible

        if isPortrait {
            toPortraitMode(size: view.bounds.size)
        } else {
            toLandscapeMode()
        }
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if isPortrait {
            toPortraitMode(size: view.bounds.size)
        } else {
            toLandscapeMode()
        }
    }
    
#if !targetEnvironment(macCatalyst)
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        var subVCs: [UIViewController] = masterViewController!.viewControllers

        // after transition, it will be portrait mode
        if !isPortrait {
            var flag: Bool = false
            if let topVC = detailViewController?.topViewController, !topVC.isKind(of: placeholderViewControllerClass) {
                subVCs.append(contentsOf: detailViewController!.viewControllers)
                flag = true
            }

            if flag {
                let placeholderViewController = (placeholderViewControllerClass as? UIViewController.Type)?.init() ?? UIViewController()

                detailViewController?.viewControllers = [placeholderViewController]
                masterViewController?.viewControllers = subVCs
            }

            toPortraitMode(size: size)
        } else {
            if subVCs.count > 1 {
                subVCs.remove(at: 0)
                masterViewController!.popToRootViewController(animated: false)
                detailViewController?.viewControllers = subVCs
            }

            toLandscapeMode()
        }
    }
#endif

    private func toPortraitMode(size: CGSize) {
        masterViewController?.view.frame = CGRect(origin: .zero, size: size)
        detailViewController?.view.frame = CGRect(x: size.width, y: 0, width: 0, height: size.height)

        maximumPrimaryColumnWidth = size.width
        preferredPrimaryColumnWidthFraction = 1
    }

    private func toLandscapeMode() {
        maximumPrimaryColumnWidth = UISplitViewController.automaticDimension
        preferredPrimaryColumnWidthFraction = UISplitViewController.automaticDimension
    }
}

extension SFSplitViewController: UISplitViewControllerDelegate {
    
    public func splitViewControllerSupportedInterfaceOrientations(_ splitViewController: UISplitViewController) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }

        return .portrait
    }

    public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    public func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        if isPortrait {
            masterViewController?.show(vc, sender: nil)
        } else {
            detailViewController?.viewControllers = [vc]
        }

        return true
    }
}
