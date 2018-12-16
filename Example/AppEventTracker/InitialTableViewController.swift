//
//  InitialTableViewController.swift
//  AppEventTracker_Example
//
//  Created by Ioannis Diamantidis on 12/16/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class InitialTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        barButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(clickButton))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func clickButton(sender: UIBarButtonItem) {

        if let popoverVC = self.storyboard?.instantiateViewController(withIdentifier: "PopoverTableViewController")
            as? PopoverTableViewController {

            popoverVC.modalPresentationStyle = .popover
            let popover: UIPopoverPresentationController = popoverVC.popoverPresentationController!
            popover.barButtonItem = sender
            popover.delegate = popoverVC
            present(popoverVC, animated: true, completion: nil)
        }
    }

    private var barButtonItem: UIBarButtonItem?
    private let cellIdentifier = "cellUniqueIdentifier"
    private let cells = [
        FirstViewController.self,
        SecondViewController.self,
        ThirdViewController.self
    ]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.textLabel?.text = "\(cells[indexPath.row])"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedVC: UIViewController?

        selectedVC = self.storyboard?.instantiateViewController(withIdentifier: "\(cells[indexPath.row])")
        selectedVC?.navigationItem.rightBarButtonItem = barButtonItem

        if let selectedVC = selectedVC {
            self.navigationController?.pushViewController(selectedVC, animated: true)
        }
    }
}
