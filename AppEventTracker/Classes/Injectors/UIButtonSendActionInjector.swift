//
//  UIButtonSendActionInjector.swift
//  AppEventTracker
//
//  Created by Ioannis Diamantidis on 12/24/18.
//

import UIKit

/// Class to inject code to the sendActions of UIControl subclasses
class UIButtonSendActionInjector {

    typealias SendActionRef = @convention(c)(UIControl, Selector, UIControl.Event) -> Void

    private static let selector = #selector(UIControl.sendActions(for:))

    static func inject(into classes: [UIControl.Type], injection: @escaping (UIControl, UIControl.Event) -> Void) {
        guard let originalMethod = class_getInstanceMethod(UIControl.self, selector) else {
            fatalError("\(selector) must be implemented")
        }

        var originalIMP: IMP?

        let swizzledBlock: @convention(block) (UIControl, UIControl.Event) -> Void = { receiver, event in
            if let originalIMP = originalIMP {
                let castedIMP = unsafeBitCast(originalIMP, to: SendActionRef.self)
                castedIMP(receiver, selector, event)
            }

            if UIButtonSendActionInjector.canInject(to: receiver, supportedClasses: classes) {
                injection(receiver, event)
            }
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(originalMethod, swizzledIMP)
    }

    private static func canInject(to receiver: Any, supportedClasses: [UIControl.Type]) -> Bool {
        return supportedClasses.map {(receiver as AnyObject).isKind(of: $0)}.contains(true)
    }
}
