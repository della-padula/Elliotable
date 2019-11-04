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
    public let courseDay : ElliotDay
    public let startTime : String
    public let endTime   : String
    public let backgroundColor: UIColor
    public let tapHandler: (ElliottEvent) -> Void
    
    public init(courseId: String, courseName: String, roomName: String, courseDay: ElliotDay,startTime: String, endTime: String, backgroundColor: UIColor,
                tapHandler: @escaping (ElliottEvent) -> Void) {
        self.courseId        = courseId
        self.courseName      = courseName
        self.roomName        = roomName
        self.courseDay       = courseDay
        self.startTime       = startTime
        self.endTime         = endTime
        self.backgroundColor = backgroundColor
        self.tapHandler      = tapHandler
    }
    
}
