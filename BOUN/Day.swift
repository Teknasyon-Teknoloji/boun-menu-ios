//
//  Day.swift
//  BOUN
//
//  Created by Omar on 3/1/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import Foundation

struct Day: Codable {

	var date: Date
	var lunch: [Meal]?
	var dinner: [Meal]?

	func meals(for type: Meal.MealType) -> [Meal] {
		switch type {
		case .lunch:
			return lunch ?? []
		case .dinner:
			return dinner ?? []
		}
	}

}
