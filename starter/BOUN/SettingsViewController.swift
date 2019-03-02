//
//  SettingsViewController.swift
//  BOUN
//
//  Created by Omar on 3/2/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {

	private let clientRepoUrl = URL(string: "https://github.com/Teknasyon-Teknoloji/boun-menu-ios")!
	private let apiRepoUrl = URL(string: "https://github.com/Teknasyon-Teknoloji/boun-menu-api")!

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.setColors(background: #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.937254902, alpha: 1), text: .white)
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			UIApplication.shared.open(clientRepoUrl, options: [:])
		case 1:
			UIApplication.shared.open(apiRepoUrl, options: [:])
		case 2:
			//TODO: Simulate crash here
			break
		default:
			break
		}
	}

}
