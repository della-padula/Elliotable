# Elliotable
Elliotable은 간단하게 대한민국 대학교 시간표를 누구나 손쉽게 구현할 수 있도록 만들어진 라이브러리입니다.   
개발자분들은 강의만 추가해주시면 기본적인 시간표를 만들 수 있으며 제공되는 다양한 옵션들을 통해 커스텀화할 수 있습니다.   
본 라이브러리는 **시간표의 시작 시각과 종료 시각을 자동으로 계산**하여 적용합니다.  
강의 아이템을 추가하면 **가장 빠른 시간**과 **가장 늦은 시간**을 계산하여 시간표를 구성해줍니다.  

### 개발자 정보
iOS 개발을 위한 시간표 라이브러리   
개발자 : 김태인 / 서울, 대한민국   
이메일 : della.kimko@gmail.com   
블로그 : https://terry-some.tistory.com/  
최신 버전 : 1.1.9 (Cocoapods)    
  
[![Version](https://img.shields.io/badge/version-v1.1.9-green.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Version](https://img.shields.io/badge/ios-11.0-blue.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Version](https://img.shields.io/cocoapods/v/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![License](https://img.shields.io/cocoapods/l/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)
[![Platform](https://img.shields.io/cocoapods/p/Elliotable.svg?style=flat)](http://cocoapods.org/pods/Elliotable)

## 스크린샷   
#### 세로 화면 및 가로 화면 시간표      
![screenshot](./screenshot_1.png)   

## 설치 방법

### Cocoapods
Elliotable은 Cocoapods을 통해 배포되었습니다. Podfile에 다음을 추가 한 후 pod install 을 통해 라이브러리를 적용할 수 있습니다. :   
```ruby
pod 'Elliotable'
```

## 라이브러리 사용    
### 요일 정보   
```swift
private let daySymbol = ["월", "화", "수", "목", "금"]   
```
### 강의 선택 핸들러 구현    
```swift
let handler = { (course: ElliottEvent) in   
    print(course.courseName, course.courseDay)   
}   
```

### 강의 아이템 구조   
```swift
courseId : 강의 고유번호(ID)   
courseName : 강의 이름 
roomName : 강의실 이름(예 : 정보과학관 21101)
courseDay : 요일
startTime : 강의 시작 시간(형식 - "HH:mm")
endTime : 강의 종료 시간(형식 - "HH:mm")
backgroundColor : 강의 아이템 배경 색상
(Optional) textColor: 강의 아이템 글씨 색상 (선택적으로 적용 가능한 옵션)
tapHandler : 강의 아이템을 탭했을 때 실행할 핸들러를 지정합니다.
```

### 사용 방법    
스토리보드에서 "View"를 추가합니다.    
Inspector 창에서 추가한 View의 class를 "Elliotable"로 선택합니다.   
![screenshot](./screenshot3.png)   
다음 사진은 view를 swift파일에 바인딩하는 것을 보여주는 스크린샷입니다.   
![screenshot](./screenshot4.png)   


우선 import를 합니다.   
```swift
import Elliotable
```
시간표 강의 아이템들을 원하는 만큼 추가해줍니다.   
```swift
let course_1 = ElliottEvent(courseId: "c0001", courseName: "Operating System", roomName: "IT Building 21204", courseDay: .tuesday, startTime: "12:00", endTime: "13:15", backgroundColor: [UIColor], tapHandler: handler)

let course_2 = ElliottEvent(courseId: "c0002", courseName: "Operating System", roomName: "IT Building 21204", courseDay: .thursday, startTime: "12:00", endTime: "13:15", textColor: UIColor.white, backgroundColor: [UIColor], tapHandler: handler)
```
아울렛 변수를 선언해주고 시간표에 강의 아이템들을 넣어줍니다.   
```swift
@IBOutlet var elliotable: Elliotable!

// Course Item List & Day Symbol
elliotable.courseItems = [course_1, course_2, course_3, course_4, course_5, course_6, course_7, course_8, course_9, course_10]
```

```swift
// 강의 아이템 둥근 모서리 속성 : .none, .all, .left(topLeft, bottomRight), .right(topRight, bottomLeft)
elliotable.roundCorner   = .none
```
![screenshot](./screenshot_round_corner.png) 

```swift
elliotable.userDaySymbol = daySymbol     
// 시간표 배경
elliotable.elliotBackgroundColor = UIColor.white
// 시간표 선 두께
elliotable.borderWidth        = 1
// 시간표 선 색상
elliotable.borderColor        = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)

// 강의 아이템의 둥근 모서리 radius 설정   
elliotable.borderCornerRadius = 24
// 강의 아이템의 텍스트 안쪽 간격 설정
elliotable.textEdgeInsets = UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 10)
// 최대 이름 길이
elliotable.courseItemMaxNameLength = 18
// 강의 정보 글자 크기
elliotable.courseItemTextSize      = 12.5
// 강의 정보 글자 정렬
elliotable.courseTextAlignment     = .left
// 강의실 이름 글자 크기
elliotable.roomNameFontSize        = 8

// 시간표 행 높이 (기본 : 60.0)
elliottable.courseItemHeight       = 70.0
// 요일 글자 크기
elliotable.symbolFontSize = 14
// 시각 글자 크기
elliotable.symbolTimeFontSize = 12
// 요일 글자 색상
elliotable.symbolFontColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
// 시각 글자 색상
elliotable.symbolTimeFontColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
// 요일/시각 배경 색상
elliotable.symbolBackgroundColor = UIColor(named: "main_bg") ?? .white  
```

