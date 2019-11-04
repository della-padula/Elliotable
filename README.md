# Elliotable
Elliotable is simple library to generate Timetable of University.   
If you only add a course, the course time is automatically calculated and added to the timetable.   

### Author Information
Timetable Library for iOS Development   
Author : Elliott Kim / Seoul, South Korea   
   
[![Version](https://img.shields.io/badge/version-v0.7.0-green.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Version](https://img.shields.io/badge/ios-v11.0-blue.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Version](https://img.shields.io/cocoapods/v/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![License](https://img.shields.io/cocoapods/l/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Platform](https://img.shields.io/cocoapods/p/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)

## Installation

### Cocoapods
Elliotable is available through CocoaPods, to install it simply add the following line to your Podfile:   
```ruby
pod "Elliotable"
```

## Usage   
### Course Item Structure   
```swift
courseName : The name of the course
roomName : The name of the lecture room
courseDay : Weekday of the course
startTime : Start time of course (String type - format : "HH:mm")
endTime : End time of course (String type - format : "HH:mm")
backgroundColor : backgroud color of each course item
tapHandler : on Touch Event Listener for each course item.
```

### How to use   
First, import my library by adding line below.   
```swift
import Elliotable
```
And then, create courses to add to the timetable.   
```swift
let course_1 = ElliottEvent(courseId: "2150000000", courseName: "Operating System", roomName: "IT Building 21204", courseDay: .tuesday, startTime: "12:00", endTime: "13:15", backgroundColor: [UIColor], tapHandler: handler)

let course_2 = ElliottEvent(courseId: "2150000000", courseName: "Operating System", roomName: "IT Building 21204", courseDay: .thursday, startTime: "12:00", endTime: "13:15", backgroundColor: [UIColor], tapHandler: handler)
```
Finally, define the properties of the timetable.   
```swift
elliotable.courseItems = [course_1, course_2, course_3, course_4, course_5, course_6, course_7, course_8, course_9, course_10]
elliotable.userDaySymbol = daySymbol
elliotable.dayCount = daySymbol.count
elliotable.backgroundColor = .white
elliotable.borderWidth = 0.5
elliotable.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
elliotable.cornerRadius = 0
elliotable.textEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
elliotable.maximumNameLength = 18
        
elliotable.textFontSize = 11
elliotable.roomNameFontSize = 8
```

On your storyboard, just add a "View" Component.     
On the Inspector Frame, choose the View class to "Elliotable"   
