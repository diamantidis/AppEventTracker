//
//  PopoverTableViewController.swift
//  AppEventTracker_Example
//
//  Created by Ioannis Diamantidis on 12/16/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import AppEventTracker
import UIKit

class PopoverTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppEventTracker.events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popoverReuseIdentifier", for: indexPath)
        let text = "\(AppEventTracker.events[indexPath.row].name) - \(AppEventTracker.events[indexPath.row].type)"
        cell.textLabel?.text = text

        return cell
    }

    // MARK: - UIPopoverPresentationControllerDelegate

    // swiftlint:disable:next line_length
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {

        return UIModalPresentationStyle.none
    }

    // swiftlint:disable:next line_length
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {

        let navigationController = PopoverNavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPopover))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }

    @objc func dismissPopover() {
        self.dismiss(animated: true, completion: nil)
    }
}
