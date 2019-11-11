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
            collectionView.register(ElliotableCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
}

extension ElliotableController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var minStartTimeHour: Int = 24
        var maxEndTimeHour: Int = 0
        
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
        
        // The number of rows in timetable
        let courseCount = maxEndTimeHour - minStartTimeHour
        // 7 = 6 + 1
        return (courseCount + 1) * (ellioTable.dayCount + 1)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElliotableCell
        cell.backgroundColor = ellioTable.symbolBackgroundColor
        cell.layer.addBorder(edge: UIRectEdge.bottom, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
        cell.textLabel.textColor = ellioTable.weekDayTextColor
        
        if indexPath.row == 0 {
            cell.textLabel.text = ""
            cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
        } else if indexPath.row < (ellioTable.dayCount + 1) {
            print("indexPath row : \(indexPath.row)")
            
            // Last Weekday doesn't have right-border.
            if indexPath.row < ellioTable.dayCount {
                cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
            }
            cell.textLabel.text = ellioTable.daySymbols[indexPath.row - 1]
            cell.textLabel.textAlignment = .center
            cell.textLabel.font = UIFont.systemFont(ofSize: ellioTable.symbolFontSize)
            cell.textLabel.textColor = ellioTable.symbolFontColor
        } else if indexPath.row % (ellioTable.dayCount + 1) == 0 {
            cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
            
            //인덱스 - 교시로 표시하는 부분이지만 주석 처리 (시간으로 보여줄 것이므로)
//            cell.textLabel.text = String(indexPath.row / (ellioTable.dayCount + 1))
            cell.textLabel.text = "\((ellioTable.minimumCourseStartTime ?? 8) - 1 + (indexPath.row / (ellioTable.dayCount + 1)))"
            // Top Right
            cell.textLabel.textAlignment = .right
            cell.textLabel.sizeToFit()
            cell.textLabel.font = UIFont.systemFont(ofSize: ellioTable.symbolTimeFontSize)
            cell.textLabel.textColor = ellioTable.symbolTimeFontColor
        } else {
            cell.textLabel.text = ""
            cell.layer.addBorder(edge: UIRectEdge.right, color: ellioTable.borderColor, thickness: ellioTable.borderWidth)
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
}

extension ElliotableController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate average Height
        var minStartTimeHour: Int = 24
        var maxEndTimeHour: Int = 0
        
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
        
        // The number of rows in timetable
        let courseCount = maxEndTimeHour - minStartTimeHour
        let averageHeight = (collectionView.frame.height - ellioTable.heightOfDaySection) / CGFloat(courseCount)
        
        if indexPath.row == 0 {
            return CGSize(width: ellioTable.widthOfTimeAxis, height: ellioTable.heightOfDaySection)
        } else if indexPath.row < (ellioTable.dayCount + 1) {
            return CGSize(width: ellioTable.averageWidth, height: ellioTable.heightOfDaySection)
        } else if indexPath.row % (ellioTable.dayCount + 1) == 0 {
            return CGSize(width: ellioTable.widthOfTimeAxis, height: averageHeight)
        } else {
            return CGSize(width: ellioTable.averageWidth, height: averageHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
