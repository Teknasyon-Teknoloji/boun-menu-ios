//
//  Extensions.swift
//  BOUN
//
//  Created by Omar on 3/1/19.
//  Copyright © 2019 Omar Albeik. All rights reserved.
//

import UIKit

extension Collection {

	/// Safe protects the array from out of bounds by use of optional.
	///
	///        let arr = [1, 2, 3, 4, 5]
	///        arr[safe: 1] -> 2
	///        arr[safe: 10] -> nil
	///
	/// - Parameter index: index of element to access element.
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}

}

extension Date {

	var dayName: String {
		let dateFormatter = DateFormatter()
		dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
		return dateFormatter.string(from: self)
	}

	func dateString(ofStyle style: DateFormatter.Style = .long) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .none
		dateFormatter.dateStyle = style
		return dateFormatter.string(from: self)
	}

	/// Check if date is within today.
	///
	/// 	Date().isInToday -> true
	///
	var isInToday: Bool {
		return Calendar.current.isDateInToday(self)
	}

}

extension UINavigationBar {

	/// Set Navigation bar's title color and font.
	///
	/// - Parameters:
	///   - font: title font
	///   - color: title text color.
	func setTitleFont(_ font: UIFont, color: UIColor) {
		var attrs = [NSAttributedString.Key: Any]()
		attrs[.font] = font
		attrs[.foregroundColor] = color
		titleTextAttributes = attrs
	}

	/// Set navigation bar's background and text colors
	///
	/// - Parameters:
	///   - background: backgound color
	///   - text: text color
	func setColors(background: UIColor, text: UIColor) {
		isTranslucent = false
		backgroundColor = background
		barTintColor = background
		setBackgroundImage(UIImage(), for: .default)
		tintColor = text
		titleTextAttributes = [.foregroundColor: text]
	}

	/// Make navigation bar transparent.
	///
	/// - Parameter tint: tint color _default value is UIColor.black_.
	func makeTransparent(withTint tint: UIColor = .black) {
		isTranslucent = true
		backgroundColor = .clear
		barTintColor = .clear
		setBackgroundImage(UIImage(), for: .default)
		tintColor = tint
		titleTextAttributes = [.foregroundColor: tint]
		shadowImage = UIImage()
	}

}
