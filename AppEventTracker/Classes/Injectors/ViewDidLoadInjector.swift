//
//  ViewDidLoadInjector.swift
//  AppEventTracker
//
//  Created by Ioannis Diamantidis on 12/16/18.
//

import UIKit

/// Class to inject code to the viewDidLoad of UIViewController subclasses
class ViewDidLoadInjector {

    typealias ViewDidLoadRef = @convention(c)(UIViewController, Selector) -> Void

    private static let viewDidLoadSelector = #selector(UIViewController.viewDidLoad)

    static func inject<T>(into classType: T.Type, injection: @escaping (UIViewController) -> Void) {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, viewDidLoadSelector) else {
            fatalError("\(viewDidLoadSelector) must be implemented")
        }

        var originalIMP: IMP?

        let swizzledViewDidLoadBlock: @convention(block) (UIViewController) -> Void = { receiver in
            if let originalIMP = originalIMP {
                let castedIMP = unsafeBitCast(originalIMP, to: ViewDidLoadRef.self)
                castedIMP(receiver, viewDidLoadSelector)
            }

            if ViewDidLoadInjector.canInject(to: receiver, classType: classType) {
                injection(receiver)
            }
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledViewDidLoadBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(originalMethod, swizzledIMP)
    }

    private static func canInject<T>(to receiver: Any, classType: T.Type) -> Bool {
        return receiver is T
    }
}
