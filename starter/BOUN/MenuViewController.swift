//
//  MenuViewController.swift
//  BOUN
//
//  Created by Omar on 3/1/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {

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

		//TODO: Fetch meals
	}

}

// MARK: - Helpers
private extension MenuViewController {

	func loadDays(_ days: [Day]) {
		self.days = days
		let index = days.firstIndex(where: { $0.date.isInToday }) ?? 0
		selectedMeals = (index, .lunch)
	}

	func showAlert(message: String) {
		//TODO: Stop Animating
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
		//TODO: Move to previous day
	}

	@IBAction func didTapNextDayButton(_ sender: UIButton) {
		//TODO: Move to next day
	}

	@IBAction func didTapLunchButton(_ sender: UIButton) {
		//TODO: Show lunch meals
	}

	@IBAction func didTapDinnerButton(_ sender: UIButton) {
		//TODO: Show dinner meals
	}

	@IBAction func didTapShareButton(_ sender: UIBarButtonItem) {
		//TODO: Share selected day meals
	}

}
