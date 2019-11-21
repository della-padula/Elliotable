//
//  ElliotableController.swift
//  Elliotable
//
//  Created by TaeinKim on 2019/11/03.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "Cell"

class ElliotableController: UIViewController {
    weak var ellioTable: Elliotable!
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isScrollEnabled = false
//            collectionView.translatesAutoresizingMaskIntoConstraints = false
//            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            collectionView.register(ElliotableCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
}

extension ElliotableController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var minStartTimeHour: Int = 24
        var maxEndTimeHour: Int = 0
        
        if ellioTable.courseItems.count < 1 {
            minStartTimeHour = ellioTable.defaultMinHour
            maxEndTimeHour = ellioTable.defaultMaxEnd
        } else {
            
            for (index, courseItem) in ellioTable.courseItems.enumerated() {
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
        }
        /*
        let sTime = Int(ellioTable.startTime.split(separator: ":")[0]) ?? 9
        let eTime = Int(ellioTable.endTime.split(separator: ":")[0]) ?? 18
        
        if sTime > ellioTable.minimumCourseStartTime! {
            print("Invalid Start Time")
        }
        
        if eTime < maxEndTimeHour {
            print("Invalid End Time")
        }
        
        minStartTimeHour = sTime
        maxEndTimeHour = eTime
         */
        
        // The number of rows in timetable
        let courseCount = maxEndTimeHour - minStartTimeHour + 1
        // 7 = 6 + 1
        print("item count : \((courseCount + 1) * (ellioTable.daySymbols.count + 1))")
        return (courseCount + 1) * (ellioTable.daySymbols.count + 1)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElliotableCell
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: cell.frame.height - 4, width: cell.frame.width - 4, height: 4)
        borderLayer.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        borderLayer.masksToBounds = true
        
        // Cell Reuse Problem must be resolved.
        for view in cell.subviews {
            if view.tag == 9 {
                view.removeFromSuperview()
            }
        }
        
        backgroundView.backgroundColor = .clear
        backgroundView.tag = 9
        backgroundView.layer.addSublayer(borderLayer)
        
//        backgroundColor = ellioTable.symbolBackgroundColor
        
//        cell.layer.addBorder(edge: UIRectEdge.bottom, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
        cell.textLabel.textColor = ellioTable.weekDayTextColor
//        cell.layer.borderWidth = ellioTable.borderWidth
//        cell.layer.borderColor = UIColor.black.cgColor
        
        if indexPath.row == 0 {
            cell.textLabel.text = ""
            cell.setNeedsDisplay()
//            cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
            backgroundView.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 0, alpha: 0.3)
        } else if indexPath.row < (ellioTable.daySymbols.count + 1) {
            if indexPath.row < ellioTable.daySymbols.count {
//                cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
            }
            cell.setNeedsDisplay()
            cell.textLabel.text = ellioTable.daySymbols[indexPath.row - 1]
            cell.textLabel.textAlignment = .center
            cell.textLabel.font = UIFont.boldSystemFont(ofSize: ellioTable.symbolFontSize)
            cell.textLabel.textColor = ellioTable.symbolFontColor
            backgroundView.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 1, alpha: 0.3)
        } else if indexPath.row % (ellioTable.daySymbols.count + 1) == 0 {
//            cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
            cell.textLabel.text = "\((ellioTable.minimumCourseStartTime ?? 9) - 1 + (indexPath.row / (ellioTable.daySymbols.count + 1)))"
            cell.setNeedsDisplay()
            
            // Top Right
            cell.textLabel.textAlignment = .right
//            cell.textLabel.topInset = -40.0
            cell.textLabel.leftInset = -3.0
            cell.textLabel.rightInset = 3.0
            cell.textLabel.sizeToFit()
            
            cell.textLabel.font = UIFont.systemFont(ofSize: ellioTable.symbolTimeFontSize)
            cell.textLabel.textColor = ellioTable.symbolTimeFontColor
            backgroundView.backgroundColor = UIColor(displayP3Red: 1, green: 0, blue: 1, alpha: 0.3)
        } else {
            cell.textLabel.text = ""
            cell.setNeedsDisplay()
//            cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
//            cell.backgroundColor = ellioTable.elliotBackgroundColor
            backgroundView.backgroundColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.1)
        }
        cell.addSubview(backgroundView)
        return cell
    }
}

extension ElliotableController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate average Height
        var minStartTimeHour: Int = 24
        var maxEndTimeHour: Int = 0
        
        if ellioTable.courseItems.count < 1 {
            minStartTimeHour = ellioTable.defaultMinHour
            maxEndTimeHour = ellioTable.defaultMaxEnd
        } else {
            for (index, courseItem) in ellioTable.courseItems.enumerated() {
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
        }
        
        // The number of rows in timetable
//        let courseCount = maxEndTimeHour - minStartTimeHour
//        let averageHeight = (collectionView.frame.height - ellioTable.heightOfDaySection) / CGFloat(courseCount)

        if indexPath.row == 0 {
            return CGSize(width: ellioTable.widthOfTimeAxis, height: ellioTable.heightOfDaySection)
        } else if indexPath.row < (ellioTable.daySymbols.count + 1) {
            return CGSize(width: ellioTable.averageWidth, height: ellioTable.heightOfDaySection)
        } else if indexPath.row % (ellioTable.daySymbols.count + 1) == 0 {
            //            return CGSize(width: ellioTable.widthOfTimeAxis, height: averageHeight)
            return CGSize(width: ellioTable.widthOfTimeAxis, height: ellioTable.courseItemHeight)
        } else {
            //            return CGSize(width: ellioTable.averageWidth, height: averageHeight)
            return CGSize(width: ellioTable.averageWidth, height: ellioTable.courseItemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected : \(indexPath.row)")
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
