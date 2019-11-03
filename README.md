# Elliotable

Timetable Library for iOS Development   
Author : Elliott Kim / Seoul, South Korea   
   
[![Version](https://img.shields.io/badge/version-v0.0.3-green.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Version](https://img.shields.io/cocoapods/v/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![License](https://img.shields.io/cocoapods/l/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Platform](https://img.shields.io/cocoapods/p/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)

## Installation

### Cocoapods

```ruby
pod "Elliotable"
```

## Usage
```swift
import Elliotable

let course_1 = ElliottEvent(courseName: "운영체제", roomName: "정보과학관 21204", courseDay: .tuesday, startTime: "12:00", endTime: "13:15", backgroundColor: [UIColor], tapHandler: handler)

let course_2 = ElliottEvent(courseName: "운영체제", roomName: "정보과학관 21204", courseDay: .thursday, startTime: "12:00", endTime: "13:15", backgroundColor: [UIColor], tapHandler: handler)

elliotable.courseItems = [course_1, course_2]
elliotable.userDaySymbol = daySymbol
elliotable.dayCount = daySymbol.count
elliotable.backgroundColor = .white
elliotable.borderWidth = 0.5
elliotable.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
elliotable.cornerRadius = 5
elliotable.textEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
elliotable.maximumNameLength = 12
```
