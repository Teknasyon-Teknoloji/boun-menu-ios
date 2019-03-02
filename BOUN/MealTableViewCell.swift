//
//  MealTableViewCell.swift
//  BOUN
//
//  Created by Omar on 3/1/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import UIKit

final class MealTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var caloriesLabel: UILabel!

	func configure(for meal: Meal) {
		nameLabel.text = meal.name
		caloriesLabel.text = meal.calories
	}

}
