//
//  SFSplitViewController.swift
//  SFSplitViewController
//
//  Created by vvveiii on 2019/5/8.
//  Copyright © 2019 lvv. All rights reserved.
//

import UIKit

public class SFSplitViewController : UISplitViewController, UISplitViewControllerDelegate {
    @objc open var masterViewController: UINavigationController? = nil
    @objc open var detailViewController: UINavigationController? = nil
    @objc open var placeholderViewControllerClass: AnyClass = UIViewController.self

    private var maxMasterWidth: CGFloat = 0
    private var isPortrait: Bool {
        get {
#if targetEnvironment(macCatalyst)
            return false
#else
            if #available(iOS 13, *) {
                return UIApplication.shared.windows.first!.windowScene!.interfaceOrientation.isPortrait
            } else {
                return UIApplication.shared.statusBarOrientation.isPortrait
            }
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
        maxMasterWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

        if isPortrait {
            toPortraitWidth()
        } else {
            toLandscapeWidth()
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

            toPortraitWidth()
        } else {
            if subVCs.count > 1 {
                subVCs.remove(at: 0)
                masterViewController!.popToRootViewController(animated: false)
                detailViewController?.viewControllers = subVCs
            }

            toLandscapeWidth()
        }
    }
#endif

    public func splitViewControllerSupportedInterfaceOrientations(_ splitViewController: UISplitViewController) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }

        return .portrait
    }

    private func toPortraitWidth() {
        maximumPrimaryColumnWidth = maxMasterWidth
        preferredPrimaryColumnWidthFraction = 1
    }

    private func toLandscapeWidth() {
        maximumPrimaryColumnWidth = UISplitViewController.automaticDimension
        preferredPrimaryColumnWidthFraction = UISplitViewController.automaticDimension
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
