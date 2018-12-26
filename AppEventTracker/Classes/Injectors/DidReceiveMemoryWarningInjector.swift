//
//  DidReceiveMemoryWarningInjector.swift
//  AppEventTracker
//
//  Created by Ioannis Diamantidis on 12/24/18.
//

import UIKit

/// Class to inject code to the didReceiveMemoryWarning of UIViewController subclasses
class DidReceiveMemoryWarningInjector {

    typealias DidReceiveMemoryWarningRef = @convention(c) (UIViewController, Selector) -> Void

    private static let selector = #selector(UIViewController.didReceiveMemoryWarning)

    static func inject<T>(into classType: T.Type, injection: @escaping (UIViewController) -> Void) {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, selector) else {
                fatalError("\(selector) must be implemented")
        }

        var originalIMP: IMP?

        let swizzledBlock: @convention(block) (UIViewController) -> Void = {receiver in
            if let originalIMP = originalIMP {
                let castedIMP = unsafeBitCast(originalIMP, to: DidReceiveMemoryWarningRef.self)
                castedIMP(receiver, selector)
            }

            if DidReceiveMemoryWarningInjector.canInject(to: receiver, classType: classType) {
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
