import UIKit

// A class that can be used to track various events.
// The events are stored in a fixed size buffer.
// Complementary to this, a completion block can be passed to be called every time an event is trigged.
// Currently it supports the tracking the calls of the UIViewController's viewDidLoad.
public class AppEventTracker {

    // MARK: - Enums, Structs, Typealiases, etc
    public enum EventType {
        case viewDidLoad
        case didReceiveMemoryWarning
        case uiButtonSendAction
    }

    public struct EventRecord {
        public var type: EventType
        public var name: String
    }

    public typealias EventHookType = ((AppEventTracker.EventType, Any?) -> Void)

    // MARK: - Public methods

    /// Method to configure the size of the events to be kept. A event hook can also be provided.
    ///
    /// - Parameters:
    ///   - size: How many of the latest events to keep.
    ///   - eventHook: A block to be called every time an event is trigged.
    public static func configure(size: Int = 10, eventHook: EventHookType? = nil) {
        buffer = FixedSizeBuffer<EventRecord>(count: size)
        hook = eventHook
    }

    /// Method to enable the viewDidLoad events.
    /// As a result, events of type `viewDidLoad` will be added to the events property
    /// and the event hook will be called
    public static func enableViewDidLoad() {
        ViewDidLoadInjector.inject(into: UIViewController.self) {
            let record = EventRecord(type: .viewDidLoad, name: "\(type(of: $0))")
            hook?(.viewDidLoad, $0)
            buffer?.push(record)
        }
    }

    /// Method to enable the didReceiveMemoryWarning events.
    /// As a result, events of type `didReceiveMemoryWarning` will be added to the events property
    /// and the event hook will be called
    public static func enableDidReceiveMemoryWarning() {
        DidReceiveMemoryWarningInjector.inject(into: UIViewController.self) {
            let record = EventRecord(type: .didReceiveMemoryWarning, name: "\(type(of: $0))")
            hook?(.didReceiveMemoryWarning, $0)
            buffer?.push(record)
        }
    }

    /// Method to enable the UIButton's sendAction events.
    /// As a result, events of type `uiButtonSendAction` will be added to the events property
    /// and the event hook will be called
    public static func enableUIButtonSendAction() {
        UIButtonSendActionInjector.inject(into: [UIButton.self]) { receiver, event in
            let record = EventRecord(type: .uiButtonSendAction, name: "\(type(of: receiver))")
            hook?(.uiButtonSendAction, receiver)
            buffer?.push(record)
        }
    }

    // MARK: - Public properties

    /// Property to return the list of events
    public static var events: [EventRecord] {
        return buffer?.list.compactMap { $0 } ?? []
    }

    // MARK: - Private properties

    private static var buffer: FixedSizeBuffer<EventRecord>?
    private static var hook: EventHookType?
}
