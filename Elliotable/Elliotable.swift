//
//  Elliotable.swift
//  Elliotable
//
//  Created by TaeinKim on 2019/11/02.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

public class Elliotable: UIView {
    private let controller     = ElliotableController()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    public var userDaySymbol: [String]?
    
    // Settable Options of Time Table View
    public var startDay = ElliotDay.monday {
        didSet {
            collectionView.reloadData()
            makeTimeTable()
        }
    }
    
    public var courseItemTextColor = UIColor.white {
        didSet {
            makeTimeTable()
        }
    }
    
    public var weekDayTextColor = UIColor.black {
        didSet {
            makeTimeTable()
        }
    }
    
    // Course Time Term Count
    public var numberOfPeriods = 10 {
        didSet {
            collectionView.reloadData()
            makeTimeTable()
        }
    }
    
    // Item for Course
    public var courseItems = [ElliottEvent]() {
        didSet {
            makeTimeTable()
        }
    }
    
    // The number of weekdays : default value is 7
    public var dayCount = 7 {
        didSet {
            makeTimeTable()
        }
    }
    
    public var hasRoundCorner = true {
        didSet {
            makeTimeTable()
        }
    }
    
    public var elliotBackgroundColor = UIColor.clear {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    public var symbolBackgroundColor = UIColor.clear {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var symbolFontSize = CGFloat(10) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var symbolTimeFontSize = CGFloat(10) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var symbolFontColor = UIColor.black {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var symbolTimeFontColor = UIColor.black {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var heightOfDaySection = CGFloat(28) {
        didSet {
            collectionView.reloadData()
            makeTimeTable()
        }
    }
    
    public var widthOfTimeAxis = CGFloat(32) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var borderWidth = CGFloat(0) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var borderColor = UIColor.clear {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var cornerRadius = CGFloat(0) {
        didSet {
            makeTimeTable()
        }
    }
    
    public var rectEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            makeTimeTable()
        }
    }
    
    public var textEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            makeTimeTable()
        }
    }
    
    public var textFontSize = CGFloat(11) {
        didSet {
            makeTimeTable()
        }
    }
    
    public var roomNameFontSize = CGFloat(9) {
        didSet {
            makeTimeTable()
        }
    }
    
    public var textAlignment = NSTextAlignment.center {
        didSet {
            makeTimeTable()
        }
    }
    
    public var isTextVerticalCenter = true {
        didSet {
            makeTimeTable()
        }
    }
    
    public var maximumNameLength = 0 {
        didSet {
            makeTimeTable()
        }
    }
    
    public var daySymbols: [String] {
        var daySymbols = [String]()
        daySymbols = userDaySymbol ?? Calendar.current.shortStandaloneWeekdaySymbols
        
        let startIndex = startDay.rawValue - 1
        daySymbols.rotate(shiftingToStart: startIndex)
        
        return daySymbols
    }
    
    public var minimumCourseStartTime: Int?
    
    var averageWidth: CGFloat {
        return (collectionView.frame.width - widthOfTimeAxis) / CGFloat(daySymbols.count) - 0.1
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        controller.ellioTable = self
        controller.collectionView = collectionView
        
        collectionView.dataSource = controller
        collectionView.delegate = controller
        collectionView.backgroundColor = backgroundColor
        addSubview(collectionView)
        makeTimeTable()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        collectionView.reloadData()
        makeTimeTable()
    }
    
    private func makeTimeTable() {
        var minStartTimeHour: Int = 24
        var maxEndTimeHour: Int = 0
        
        for subview in subviews {
            if !(subview is UICollectionView) {
                subview.removeFromSuperview()
            }
        }
        
        // Calculate Min StartTime
        for (index, courseItem) in courseItems.enumerated() {
            let tempStartTimeHour = Int(courseItem.startTime.split(separator: ":")[0]) ?? 24
            let tempEndTimeHour   = Int(courseItem.endTime.split(separator: ":")[0]) ?? 00
            
            if index < 1 {
                minStartTimeHour = tempStartTimeHour
                maxEndTimeHour   = tempEndTimeHour
            } else {
                if tempStartTimeHour < minStartTimeHour {
                    minStartTimeHour = tempStartTimeHour
                }
                
                if tempEndTimeHour > maxEndTimeHour {
                    maxEndTimeHour = tempEndTimeHour
                }
            }
        }
        
        maxEndTimeHour += 1
        minimumCourseStartTime = minStartTimeHour
        
        // The number of rows in timetable
        let courseCount = maxEndTimeHour - minStartTimeHour
        
        for (index, courseItem) in courseItems.enumerated() {
            let weekdayIndex = (courseItem.courseDay.rawValue - startDay.rawValue + daySymbols.count) % daySymbols.count
            
            let courseStartHour = Int(courseItem.startTime.split(separator: ":")[0]) ?? 24
            let courseStartMin  = Int(courseItem.startTime.split(separator: ":")[1]) ?? 00
            
            let courseEndHour = Int(courseItem.endTime.split(separator: ":")[0]) ?? 24
            let courseEndMin  = Int(courseItem.endTime.split(separator: ":")[1]) ?? 00
            
            let averageHeight = (collectionView.frame.height - heightOfDaySection) / CGFloat(courseCount)
            
            // Cell X Position and Y Position
            let position_x = widthOfTimeAxis + averageWidth * CGFloat(weekdayIndex) + rectEdgeInsets.left
            
            // 요일 높이 + 평균 셀 높이 * 시간 차이 개수 + 분에 대한 추가 여백
            let position_y = heightOfDaySection + averageHeight * CGFloat(courseStartHour - minStartTimeHour) +
                CGFloat((CGFloat(courseStartMin) / 60) * averageHeight) + rectEdgeInsets.top
            
            let width = averageWidth - rectEdgeInsets.left - rectEdgeInsets.right
            let height = averageHeight * CGFloat(courseEndHour - courseStartHour) +
                CGFloat((CGFloat(courseEndMin - courseStartMin) / 60) * averageHeight) - rectEdgeInsets.top - rectEdgeInsets.bottom
            
            // If Round Option is off, set cornerRadius to Zero.
            if !self.hasRoundCorner { self.cornerRadius = 0 }
            
            let view = UIView(frame: CGRect(x: position_x, y: position_y, width: width, height: height))
            view.backgroundColor = courseItem.backgroundColor
            view.layer.cornerRadius = cornerRadius
            // Bottom Right, Top Left
//            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
            view.roundCorners([.layerMaxXMaxYCorner, .layerMinXMinYCorner], radius: cornerRadius)
            view.layer.masksToBounds = true
//            view.clipsToBounds = true
            
            let label = UILabel(frame: CGRect(x: textEdgeInsets.left, y: textEdgeInsets.top, width: view.frame.width - textEdgeInsets.left - textEdgeInsets.right, height: view.frame.height - textEdgeInsets.top - textEdgeInsets.bottom))
            var name = courseItem.courseName
            
            if maximumNameLength > 0 {
                name.truncate(maximumNameLength)
            }
            
            let attrStr = NSMutableAttributedString(string: name + "\n" + courseItem.roomName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: roomNameFontSize)])
            attrStr.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textFontSize)], range: NSRange(0..<name.count))
            
            label.attributedText = attrStr
            label.textColor = courseItemTextColor
            label.textAlignment = textAlignment
            label.numberOfLines = 0
            label.tag = index
            
            if !self.isTextVerticalCenter {
                label.sizeToFit()
            }
            
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(curriculumTapped)))
            label.isUserInteractionEnabled = true
            
            view.addSubview(label)
            addSubview(view)
        }
    }
    
    @objc func curriculumTapped(_ sender: UITapGestureRecognizer) {
        let course = courseItems[(sender.view as! UILabel).tag]
        course.tapHandler(course)
    }
}

extension Array {
    func rotated(shiftingToStart middle: Index) -> Array {
        return Array(suffix(count - middle) + prefix(middle))
    }
    
    mutating func rotate(shiftingToStart middle: Index) {
        self = rotated(shiftingToStart: middle)
    }
}

extension String {
    func truncated(_ length: Int) -> String {
        let end = index(startIndex, offsetBy: length, limitedBy: endIndex) ?? endIndex
        return String(self[..<end])
    }
    
    mutating func truncate(_ length: Int) {
        self = truncated(length)
    }
}

extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
