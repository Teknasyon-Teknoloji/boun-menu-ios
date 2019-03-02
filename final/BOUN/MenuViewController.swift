//
//  MenuViewController.swift
//  BOUN
//
//  Created by Omar on 3/1/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class MenuViewController: UIViewController, NVActivityIndicatorViewable {

	var days: [Day] = []

	var selectedMeals: (index: Int, type: Meal.MealType) = (0, .lunch) {
		didSet {
			guard let day = days[safe: selectedMeals.index] else { return }
			dateLabel.text = day.date.dateString()
			dayLabel.text = day.date.dayName
			meals = day.meals(for: selectedMeals.type)

			switch selectedMeals.type {
			case .lunch:
				lunchButton.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.937254902, alpha: 1)
				dinnerButton.backgroundColor = .clear
			case .dinner:
				lunchButton.backgroundColor = .clear
				dinnerButton.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.937254902, alpha: 1)
			}

		}
	}

	var meals: [Meal] = [] {
		didSet {
			tableView.reloadData()
		}
	}

	let defaultSession = URLSession(configuration: .default)
	var dataTask: URLSessionDataTask?

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!

	@IBOutlet weak var lunchButton: UIButton!
	@IBOutlet weak var dinnerButton: UIButton!

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.dataSource = self
		tableView.delegate = self

		navigationController?.navigationBar.makeTransparent(withTint: .white)

		fetchMeals()
	}

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell") as! MealTableViewCell
		cell.configure(for: meals[indexPath.row])
		return cell
	}

}

// MARK: - Networking
private extension MenuViewController {

	func fetchMeals() {
		let url = URL(string: "https://boun-menu.herokuapp.com/")!
		dataTask?.cancel()

		startAnimating()

		dataTask = defaultSession.dataTask(with: url) { data, _, error in
			defer { self.dataTask = nil }

			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .secondsSince1970

			guard
				let data = data,
				let days = try? decoder.decode([Day].self, from: data)
			else {
				DispatchQueue.main.async { [weak self] in
					let message = error?.localizedDescription ?? "Unknow Server Error"
					self?.showAlert(message: message)
				}
				return
			}

			DispatchQueue.main.async { [weak self] in
				self?.stopAnimating()
				self?.loadDays(days)
			}
		}
		dataTask?.resume()
	}

	private func loadDays(_ days: [Day]) {
		self.days = days
		let index = days.firstIndex(where: { $0.date.isInToday }) ?? 0
		selectedMeals = (index, .lunch)
	}

	private func showAlert(message: String) {
		stopAnimating()
		let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
		let retry = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
			self?.fetchMeals()
		}
		alert.addAction(retry)
		present(alert, animated: true)
	}

}

// MARK: - Actions
private extension MenuViewController {

	@IBAction func didTapPreviousDayButton(_ sender: UIButton) {
		guard selectedMeals.index > 0 else { return }
		selectedMeals.index -= 1
	}

	@IBAction func didTapNextDayButton(_ sender: UIButton) {
		guard selectedMeals.index < days.count - 1 else { return }
		selectedMeals.index += 1
	}

	@IBAction func didTapLunchButton(_ sender: UIButton) {
		selectedMeals.type = .lunch
	}

	@IBAction func didTapDinnerButton(_ sender: UIButton) {
		selectedMeals.type = .dinner
	}

	@IBAction func didTapShareButton(_ sender: UIBarButtonItem) {
		let day = days[selectedMeals.index]
		let shareString = day.shareString

		let activityViewController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
		present(activityViewController, animated: true)
	}

}
