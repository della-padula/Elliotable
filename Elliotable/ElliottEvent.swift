//
//  ElliottEvent.swift
//  Elliotable
//
//  Created by TaeinKim on 2019/11/02.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

public struct ElliottEvent {
    public let courseId  : String
    public let courseName: String
    public let roomName  : String
    public let professor : String
    public let courseDay : ElliotDay
    public let startTime : String
    public let endTime   : String
    public let textColor      : UIColor?
    public let backgroundColor: UIColor
    
    public init(courseId: String, courseName: String, roomName: String, professor: String, courseDay: ElliotDay,startTime: String, endTime: String, textColor: UIColor?, backgroundColor: UIColor) {
        self.courseId        = courseId
        self.courseName      = courseName
        self.roomName        = roomName
        self.professor       = professor
        self.courseDay       = courseDay
        self.startTime       = startTime
        self.endTime         = endTime
        self.textColor       = textColor
        self.backgroundColor = backgroundColor
    }
    
    public init(courseId: String, courseName: String, roomName: String, professor: String, courseDay: ElliotDay,startTime: String, endTime: String, backgroundColor: UIColor) {
        self.courseId        = courseId
        self.courseName      = courseName
        self.roomName        = roomName
        self.professor       = professor
        self.courseDay       = courseDay
        self.startTime       = startTime
        self.endTime         = endTime
        self.textColor       = UIColor.white
        self.backgroundColor = backgroundColor
    }
    
}
