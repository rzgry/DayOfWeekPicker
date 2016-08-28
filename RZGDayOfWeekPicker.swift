//
//  RZGDayOfWeekPicker.swift
//  DayOfTheWeekPicker
//
//  Created by Ryan Zegray on 2016-08-27.
//  Copyright © 2016 Ryan Zegray. All rights reserved.
//

import UIKit

@objc protocol RZGDayOfWeekPickerDelegate {
    optional func dayWasSelected(picker: RZGDayOfWeekPicker, selectedIndex: Int)
    optional func dayWasDeselected(picker: RZGDayOfWeekPicker, deselectedIndex: Int)
}

@IBDesignable
class RZGDayOfWeekPicker: UIView {
    
    var delegate: RZGDayOfWeekPickerDelegate?
    
    // MARK: Attribute Inspector variables
    
    @IBInspectable
    var unselectedColor: UIColor = UIColor.blackColor() { didSet { customizeButtonAppearance() } }
    
    @IBInspectable
    var selectedColor: UIColor = UIColor.redColor() { didSet { customizeButtonAppearance() }}
    
    @IBInspectable
    var textColor: UIColor = UIColor.whiteColor() { didSet { customizeButtonAppearance() } }
    
    @IBInspectable
    var fontSize: CGFloat = 16 { didSet { customizeButtonAppearance() } }
    
    @IBInspectable
    var spacing: CGFloat = 5 { didSet { positionButtons() } }
    
    // MARK: Instance variables and structs
    
    private struct RZGDayOfWeekPickerDay {
        var name: String
        var selected: Bool
    }
    
    private var daysOfWeek = [
        RZGDayOfWeekPickerDay(name: "S", selected: false),
        RZGDayOfWeekPickerDay(name: "M", selected: false),
        RZGDayOfWeekPickerDay(name: "T", selected: false),
        RZGDayOfWeekPickerDay(name: "W", selected: false),
        RZGDayOfWeekPickerDay(name: "T", selected: false),
        RZGDayOfWeekPickerDay(name: "F", selected: false),
        RZGDayOfWeekPickerDay(name: "S", selected: false),
    ]
    
    private var daysOfWeekButtons = [UIButton]()
    
    // MARK: Inits
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createButtons()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createButtons()
    }
    
    // MARK: Placing and Customizing the button's
    
    /// Creates and places the buttons for each day of the week
    private func createButtons() {
        for _ in daysOfWeek {
            let button = UIButton()
            button.addTarget(self, action: #selector(RZGDayOfWeekPicker.dayOfWeekButtonTapped(_:)), forControlEvents: [.TouchDown,.TouchDragEnter, .TouchDragExit])
            daysOfWeekButtons.append(button)
            addSubview(button)
        }
    }
    
    /// Positions each button within the frame
    private func positionButtons() {
        let areaUsedBySpacing = spacing * CGFloat(daysOfWeek.count + 1)
        let buttonSideLength = min((frame.width - areaUsedBySpacing) / CGFloat(daysOfWeek.count), frame.height)
        let buttonSize = CGSize(width: buttonSideLength, height: buttonSideLength)
        
        for (index, button) in daysOfWeekButtons.enumerate() {
            let buttonOrigin = CGPoint(x: spacing + (CGFloat(index) * (buttonSideLength + spacing)), y: 0)
            button.frame = CGRect(origin: buttonOrigin, size: buttonSize)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.setTitle(daysOfWeek[index].name, forState: UIControlState.Normal)
        }
    }
    
    /// Customizes the appearance of each button
    private func customizeButtonAppearance() {
        for (index, button) in daysOfWeekButtons.enumerate() {
            button.backgroundColor = daysOfWeek[index].selected ?  selectedColor :  unselectedColor
            button.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
            button.setTitleColor(textColor, forState: UIControlState.Normal)
        }
    }
    
    override func layoutSubviews() {
        positionButtons()
        customizeButtonAppearance()
    }
    
    // MARK: DayOfWeekPicker User Interaction
    
    @objc private func dayOfWeekButtonTapped(sender: UIButton) {
        if let index = daysOfWeekButtons.indexOf(sender) {
            if daysOfWeek[index].selected == true {
                deselectDayWithIndex(index)
            } else {
                selectDayWithIndex(index)
            }
        }
    }
    
    // MARK: Methods for getting and setting the data in the DayOfTheWeekPicker
    
    /// Given a index of a day it returns if that day is selected.
    func dayIsSelectedAtIndex(index: Int) -> Bool {
        if index >= 0 && index < 7 {
            return daysOfWeek[index].selected
        } else {
            return false
        }
    }
    
    /// Returns an array of ints for all selected days
    func indexOfSelectedDays() -> [Int] {
        return daysOfWeek.enumerate().filter( { $0.element.selected == true } ).map( { $0.index })
    }
    
    /// Sets the day with the index given to selected
    func selectDayWithIndex(index: Int) {
        if index >= 0 && index < 7 {
            daysOfWeek[index].selected = true
            daysOfWeekButtons[index].backgroundColor = UIColor.redColor()
            delegate?.dayWasSelected?(self, selectedIndex: index)
        }
    }
    
    /// Sets the day with the index given to not-selected
    func deselectDayWithIndex(index: Int) {
        if index >= 0 && index < 7 {
            daysOfWeek[index].selected = false
            daysOfWeekButtons[index].backgroundColor = unselectedColor
            delegate?.dayWasDeselected?(self, deselectedIndex: index)
        }
    }

}
