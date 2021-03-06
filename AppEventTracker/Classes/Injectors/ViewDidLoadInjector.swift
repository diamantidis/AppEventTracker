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

    private static let selector = #selector(UIViewController.viewDidLoad)

    static func inject<T>(into classType: T.Type, injection: @escaping (UIViewController) -> Void) {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, selector) else {
            fatalError("\(selector) must be implemented")
        }

        var originalIMP: IMP?

        let swizzledBlock: @convention(block) (UIViewController) -> Void = { receiver in
            if let originalIMP = originalIMP {
                let castedIMP = unsafeBitCast(originalIMP, to: ViewDidLoadRef.self)
                castedIMP(receiver, selector)
            }

            if ViewDidLoadInjector.canInject(to: receiver, classType: classType) {
                injection(receiver)
            }
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(originalMethod, swizzledIMP)
    }

    private static func canInject<T>(to receiver: Any, classType: T.Type) -> Bool {
        return receiver is T
    }
}
