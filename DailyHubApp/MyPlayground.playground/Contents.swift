//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let formatter = DateFormatter()
formatter.calendar = Calendar(identifier: .iso8601)
// Eastern Standard Time
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(abbreviation: "EST")
formatter.dateFormat = "yyyy-MM-dd"
print(formatter.string(from: Date()))