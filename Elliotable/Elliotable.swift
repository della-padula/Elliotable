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
    
    public var elliotDayOption = ElliotDayType.shortType {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // Settable Options of Time Table View
    
    public var startDay = ElliotDay.monday {
        didSet {
            collectionView.reloadData()
            makeTimeTable()
        }
    }
    
    // Course Time Term Count
    public var numberOfPeriods = 13 {
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
    
    public var symbolFontSize = CGFloat(14) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var heightOfDaySymbols = CGFloat(28) {
        didSet {
            collectionView.reloadData()
            makeTimeTable()
        }
    }
    
    public var widthOfPeriodSymbol = CGFloat(32) {
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
            
        }
    }
    
    public var rectEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            
        }
    }
    
    public var textEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            
        }
    }
    
    public var textFontSize = CGFloat(11) {
        didSet {
            
        }
    }
    
    public var textAlignment = NSTextAlignment.center {
        didSet {
            
        }
    }
    
    public var maximumNameLength = 0 {
        didSet {
            
        }
    }
    
    var daySymbols: [String] {
        var daySymbols = [String]()
        
        switch elliotDayOption {
        case .normalType:
            daySymbols = Calendar.current.standaloneWeekdaySymbols
            break
        case .shortType:
            daySymbols = Calendar.current.shortStandaloneWeekdaySymbols
            break
        case .shortestType:
            daySymbols = Calendar.current.veryShortStandaloneWeekdaySymbols
            break
        }
        
        let startIndex = startDay.rawValue - 1
        daySymbols.rotate(shiftingToStart: startIndex)
        
        return daySymbols
    }
    
    var averageWidth: CGFloat {
        return (collectionView.frame.width - widthOfPeriodSymbol) / 7 - 0.1
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
            print(courseItem.startTime.split(separator: ":")[0])
        }
        
        maxEndTimeHour += 1
        
        // The number of rows in timetable
        let courseCount = maxEndTimeHour - minStartTimeHour
        
        for (index, courseItem) in courseItems.enumerated() {
            let weekdayIndex = (courseItem.courseDay.rawValue - startDay.rawValue + 7) % 7
            
            let courseStartHour = Int(courseItem.startTime.split(separator: ":")[0]) ?? 24
            let courseStartMin  = Int(courseItem.startTime.split(separator: ":")[1]) ?? 00
            
            let courseEndHour = Int(courseItem.endTime.split(separator: ":")[0]) ?? 24
            let courseEndMin  = Int(courseItem.endTime.split(separator: ":")[1]) ?? 00
            
            let averageHeight = (collectionView.frame.height - heightOfDaySymbols) / CGFloat(courseCount)
            
            // Cell X Position and Y Position
            let x = widthOfPeriodSymbol + averageWidth * CGFloat(weekdayIndex) + rectEdgeInsets.left
            
            // 요일 높이 + 평균 셀 높이 * 시간 차이 개수 + 분에 대한 추가 여백
            let y = heightOfDaySymbols + averageHeight * CGFloat(courseStartHour - minStartTimeHour) +
                CGFloat(CGFloat(courseStartMin / 60) * averageHeight) + rectEdgeInsets.top
            
            let width = averageWidth - rectEdgeInsets.left - rectEdgeInsets.right
            let height = averageHeight * CGFloat(courseEndHour - courseStartHour) +
                CGFloat(CGFloat(courseEndMin - courseStartMin) * averageHeight) - rectEdgeInsets.top - rectEdgeInsets.bottom
            
            let view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
            view.backgroundColor = courseItem.backgroundColor
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
            
            let label = UILabel(frame: CGRect(x: textEdgeInsets.left, y: textEdgeInsets.top, width: view.frame.width - textEdgeInsets.left - textEdgeInsets.right, height: view.frame.height - textEdgeInsets.top - textEdgeInsets.bottom))
            var name = courseItem.courseName
            
            if maximumNameLength > 0 {
                name.truncate(maximumNameLength)
            }
            
            let attrStr = NSMutableAttributedString(string: name + "\n\n" + courseItem.roomName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textFontSize)])
            attrStr.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textFontSize)], range: NSRange(0..<name.count))
            
            label.attributedText = attrStr
            label.textColor = .white
            label.textAlignment = textAlignment
            label.numberOfLines = 0
            label.tag = index
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(curriculumTapped)))
            label.isUserInteractionEnabled = true
            
            view.addSubview(label)
            addSubview(view)
        }
    }
    
    @objc func curriculumTapped(_ sender: UITapGestureRecognizer) {
        let course = courseItems[(sender.view as! UILabel).tag]
        //course.tapHandler(course)
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
