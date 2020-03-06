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
    weak var elliotable: Elliotable!
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isScrollEnabled = true
            collectionView.register(ElliotableCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
}

extension ElliotableController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var minStartTimeHour: Int = 09
        var maxEndTimeHour: Int = 17
        
        if elliotable.courseItems.count < 1 {
            minStartTimeHour = elliotable.defaultMinHour
            maxEndTimeHour = elliotable.defaultMaxEnd
        } else {
            
            for (index, courseItem) in elliotable.courseItems.enumerated() {
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
        let courseCount = maxEndTimeHour - minStartTimeHour + 1
        // 7 = 6 + 1
        return (courseCount + 1) * (elliotable.daySymbols.count + 1)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell           = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElliotableCell
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        let titleLabel     = PaddingLabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        
        backgroundView.layer.addBorder(edge: UIRectEdge.bottom, color: elliotable.borderColor, thickness: elliotable.borderWidth)
        backgroundView.backgroundColor = .clear
        backgroundView.tag = 9
        
        for view in cell.subviews {
            if view.tag == 9 {
                view.removeFromSuperview()
            }
        }
        
        cell.textLabel.textColor = elliotable.weekDayTextColor
        
        // 0,0
        if indexPath.row == 0 {
            titleLabel.text = ""
            cell.setNeedsDisplay()
            backgroundView.backgroundColor = elliotable.symbolBackgroundColor
            
            if elliotable.isFullBorder {
                backgroundView.layer.addBorder(edge: UIRectEdge.left, color: elliotable.borderColor, thickness: elliotable.borderWidth)
            
                backgroundView.layer.addBorder(edge: UIRectEdge.top, color: elliotable.borderColor, thickness: elliotable.borderWidth)
            }
            
            backgroundView.layer.addBorder(edge: UIRectEdge.right, color: elliotable.borderColor, thickness: elliotable.borderWidth)
            
        } else if indexPath.row < (elliotable.daySymbols.count + 1) {
            // Week Day Section
            if indexPath.row < elliotable.daySymbols.count {
                if elliotable.isFullBorder {
                    backgroundView.layer.addBorder(edge: UIRectEdge.top, color: elliotable.borderColor, thickness: elliotable.borderWidth)
                }
                
                backgroundView.layer.addBorder(edge: UIRectEdge.right, color: elliotable.borderColor, thickness: elliotable.borderWidth)
            } else {
                if elliotable.isFullBorder {
                    backgroundView.layer.addBorder(edge: UIRectEdge.top, color: elliotable.borderColor, thickness: elliotable.borderWidth)
                    
                    backgroundView.layer.addBorder(edge: UIRectEdge.right, color: elliotable.borderColor, thickness: elliotable.borderWidth)
                }
            }
            cell.setNeedsDisplay()
            
            titleLabel.text = elliotable.daySymbols[indexPath.row - 1]
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.boldSystemFont(ofSize: elliotable.symbolFontSize)
            titleLabel.textColor = elliotable.symbolFontColor
            backgroundView.backgroundColor = elliotable.symbolBackgroundColor
            
        } else if indexPath.row % (elliotable.daySymbols.count + 1) == 0 {
            // Time Section
            if elliotable.isFullBorder {
                backgroundView.layer.addBorder(edge: UIRectEdge.left, color: elliotable.borderColor, thickness: elliotable.borderWidth)
            }
            backgroundView.layer.addBorder(edge: UIRectEdge.right, color: elliotable.borderColor, thickness: elliotable.borderWidth)
            titleLabel.text = "\((elliotable.minimumCourseStartTime ?? 9) - 1 + (indexPath.row / (elliotable.daySymbols.count + 1)))"
            titleLabel.textAlignment = .right
            titleLabel.sizeToFit()
            titleLabel.rightInset = 3
            titleLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: titleLabel.frame.height)
            titleLabel.font = UIFont.systemFont(ofSize: elliotable.symbolTimeFontSize)
            titleLabel.textColor = elliotable.symbolTimeFontColor
            backgroundView.backgroundColor = elliotable.symbolBackgroundColor
            
        } else {
            cell.textLabel.text = ""
            cell.setNeedsDisplay()
            backgroundView.layer.addBorder(edge: UIRectEdge.right, color: elliotable.borderColor, thickness: elliotable.borderWidth)
            backgroundView.backgroundColor = elliotable.elliotBackgroundColor
            
        }
        
        backgroundView.addSubview(titleLabel)
        cell.addSubview(backgroundView)
        return cell
    }
}

extension ElliotableController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate average Height
        var minStartTimeHour: Int = 24
        var maxEndTimeHour: Int = 0
        
        if elliotable.courseItems.count < 1 {
            minStartTimeHour = elliotable.defaultMinHour
            maxEndTimeHour = elliotable.defaultMaxEnd
        } else {
            for (index, courseItem) in elliotable.courseItems.enumerated() {
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
        
        if indexPath.row == 0 {
            return CGSize(width: elliotable.widthOfTimeAxis, height: elliotable.heightOfDaySection)
        } else if indexPath.row < (elliotable.daySymbols.count + 1) {
            return CGSize(width: elliotable.averageWidth, height: elliotable.heightOfDaySection)
        } else if indexPath.row % (elliotable.daySymbols.count + 1) == 0 {
            return CGSize(width: elliotable.widthOfTimeAxis, height: elliotable.courseItemHeight)
        } else {
            return CGSize(width: elliotable.averageWidth, height: elliotable.courseItemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected : \(indexPath.row)")
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
