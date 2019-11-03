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
        // 7 = 6 + 1(좌측 열 1개)
        return (courseCount + 1) * (ellioTable.dayCount + 1)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElliotableCell
        cell.backgroundColor = ellioTable.symbolBackgroundColor
        cell.layer.borderWidth = ellioTable.borderWidth
        cell.layer.borderColor = ellioTable.borderColor.cgColor
        cell.textLabel.font = UIFont.systemFont(ofSize: ellioTable.symbolFontSize)
        
        if indexPath.row == 0 {
            cell.textLabel.text = ""
        } else if indexPath.row < (ellioTable.dayCount + 1) {
            print("indexPath row : \(indexPath.row)")
            cell.textLabel.text = ellioTable.daySymbols[indexPath.row - 1]
        } else if indexPath.row % (ellioTable.dayCount + 1) == 0 {
            cell.textLabel.text = String(indexPath.row / (ellioTable.dayCount + 1))
        } else {
            cell.textLabel.text = ""
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
        let averageHeight = (collectionView.frame.height - ellioTable.heightOfDaySymbols) / CGFloat(courseCount)
        
        if indexPath.row == 0 {
            return CGSize(width: ellioTable.widthOfPeriodSymbol, height: ellioTable.heightOfDaySymbols)
        } else if indexPath.row < (ellioTable.dayCount + 1) {
            return CGSize(width: ellioTable.averageWidth, height: ellioTable.heightOfDaySymbols)
        } else if indexPath.row % (ellioTable.dayCount + 1) == 0 {
            return CGSize(width: ellioTable.widthOfPeriodSymbol, height: averageHeight)
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
