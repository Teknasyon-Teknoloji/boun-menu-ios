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

		fetchFoods()
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

	func fetchFoods() {
		let url = URL(string: "https://boun-menu.herokuapp.com/")!
		dataTask?.cancel()
		dataTask = defaultSession.dataTask(with: url) { data, _, error in
			defer { self.dataTask = nil }

			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .secondsSince1970

			guard
				let data = data,
				let days = try? decoder.decode([Day].self, from: data)
			else {
				print(error?.localizedDescription ?? "Unknow Server Error")
				return
			}

			DispatchQueue.main.async { [weak self] in
				self?.days = days
				self?.selectedMeals = (0, .lunch)
			}
		}
		dataTask?.resume()
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

}
