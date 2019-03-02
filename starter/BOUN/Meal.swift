//
//  Meal.swift
//  BOUN
//
//  Created by Omar on 3/1/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import Foundation

struct Meal: Codable {

	enum MealType {
		case lunch
		case dinner
	}

	var name: String
	var calories: String?

}
