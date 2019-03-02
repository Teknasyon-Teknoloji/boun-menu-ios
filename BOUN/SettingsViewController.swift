//
//  SettingsViewController.swift
//  BOUN
//
//  Created by Omar on 3/2/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import UIKit
import UserNotifications

final class SettingsViewController: UITableViewController {

	@IBOutlet weak var notificationsSwitch: UISwitch!

	private let repoUrl = URL(string: "https://github.com/Teknasyon-Teknoloji")!
	private let center =  UNUserNotificationCenter.current()

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.setColors(background: #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.937254902, alpha: 1), text: .white)

		center.getNotificationSettings { settings in
			DispatchQueue.main.async {
				self.notificationsSwitch.isOn = settings.authorizationStatus == .authorized
			}
		}

	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.row == 1 else { return }
		UIApplication.shared.open(repoUrl, options: [:])
	}

}

// MARK: - Actions
private extension SettingsViewController {

	@IBAction func didChangeNotificationsSwitch(_ sender: UISwitch) {
		if sender.isOn {
			requestNotificationsPermission(sender: sender)
		} else {
			removeNotifications()
		}
	}

}

private extension SettingsViewController {

	func requestNotificationsPermission(sender: UISwitch) {
		center.requestAuthorization(options: [.alert, .sound]) { (result, error) in
			guard result else {
				DispatchQueue.main.async {
					sender.isOn = false
					self.showUnauthorizedAlert()
				}
				return
			}
			DispatchQueue.main.async {
				sender.isOn = true
			}
		}
	}

	func removeNotifications() {

	}

	func showUnauthorizedAlert() {
		let alert = UIAlertController(title: "Unauthorized", message: "Please enable notications from settings.", preferredStyle: .alert)

		let settings = UIAlertAction(title: "Settings", style: .default) { _ in
			let url = URL(string: UIApplication.openSettingsURLString)!
			UIApplication.shared.open(url, options: [:])
		}

		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		alert.addAction(settings)
		alert.addAction(cancel)

		present(alert, animated: true, completion: nil)
	}

}
