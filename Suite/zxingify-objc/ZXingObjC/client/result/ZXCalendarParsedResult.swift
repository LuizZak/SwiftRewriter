// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXCalendarParsedResult.h"
var ZX_DATE_TIME: NSRegularExpression! = nil
var ZX_RFC2445_DURATION: NSRegularExpression! = nil
var ZX_RFC2445_DURATION_FIELD_UNITS: UnsafePointer<CLong>!

/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// 1 week
// 1 day
// 1 hour
// 1 minute
// 1 second
@objc
class ZXCalendarParsedResult: ZXParsedResult {
    private var _summary: String!
    private var _start: Date!
    private var _startAllDay: Bool = false
    private var _end: Date!
    private var _endAllDay: Bool = false
    private var _location: String!
    private var _organizer: String!
    private var _attendees: NSArray!
    private var _resultDescription: String!
    private var _latitude: CDouble = 0.0
    private var _longitude: CDouble = 0.0
    @objc var summary: String! {
        return self._summary
    }
    @objc var start: Date! {
        return self._start
    }
    @objc var startAllDay: Bool {
        return self._startAllDay
    }
    @objc var end: Date! {
        return self._end
    }
    @objc var endAllDay: Bool {
        return self._endAllDay
    }
    @objc var location: String! {
        return self._location
    }
    @objc var organizer: String! {
        return self._organizer
    }
    @objc var attendees: NSArray! {
        return self._attendees
    }
    @objc var resultDescription: String! {
        return self._resultDescription
    }
    @objc var latitude: CDouble {
        return self._latitude
    }
    @objc var longitude: CDouble {
        return self._longitude
    }

    @objc
    init(summary: String!, startString: String!, endString: String!, durationString: String!, location: String!, organizer: String!, attendees: NSArray!, description: String!, latitude: CDouble, longitude: CDouble) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeCalendar) {
            _summary = summary
            _start = self.parseDate(startString)

            if endString == nil {
                let durationMS = self.parseDurationMS(durationString)

                _end = (durationMS < 0) ? nil : Date.dateWithTimeIntervalSince1970(_start.timeIntervalSince1970 + durationMS / 1000)
            } else {
                _end = self.parseDate(endString)
            }

            _startAllDay = startString.length == 8

            _endAllDay = endString != nil && endString.length == 8

            _location = location

            _organizer = organizer

            _attendees = attendees

            _resultDescription = description

            _latitude = latitude

            _longitude = longitude
        }

        return self
    }

    @objc
    static func initialize() {
        if self.self != ZXCalendarParsedResult.self {
            return
        }

        ZX_DATE_TIME = NSRegularExpression(pattern: "[0-9]{8}(T[0-9]{6}Z?)?", options: 0, error: nil)
        ZX_RFC2445_DURATION = NSRegularExpression(pattern: "P(?:(\\\\d+)W)?(?:(\\\\d+)D)?(?:T(?:(\\\\d+)H)?(?:(\\\\d+)M)?(?:(\\\\d+)S)?)?", options: NSRegularExpressionCaseInsensitive, error: nil)
    }
    @objc
    static func calendarParsedResultWithSummary(_ summary: String!, startString: String!, endString: String!, durationString: String!, location: String!, organizer: String!, attendees: NSArray!, description: String!, latitude: CDouble, longitude: CDouble) -> AnyObject? {
        return self.init(summary: summary, startString: startString, endString: endString, durationString: durationString, location: location, organizer: organizer, attendees: attendees, description: description, latitude: latitude, longitude: longitude)
    }
    @objc
    func displayResult() -> String? {
        let result = NSMutableString(capacity: 100)

        ZXParsedResult.maybeAppend(self.summary, result: result)
        ZXParsedResult.maybeAppend(self.format(self.startAllDay, date: self.start), result: result)
        ZXParsedResult.maybeAppend(self.format(self.endAllDay, date: self.end), result: result)
        ZXParsedResult.maybeAppend(self.location, result: result)
        ZXParsedResult.maybeAppend(self.organizer, result: result)
        ZXParsedResult.maybeAppendArray(self.attendees, result: result)
        ZXParsedResult.maybeAppend(self.description, result: result)

        return result
    }
    /**
 * Parses a string as a date. RFC 2445 allows the start and end fields to be of type DATE (e.g. 20081021)
 * or DATE-TIME (e.g. 20081021T123000 for local time, or 20081021T123000Z for UTC).
 */
    @objc
    func parseDate(_ when: String!) -> Date {
        let matches: NSArray! = ZX_DATE_TIME.matchesInString(when, options: 0, range: NSMakeRange(0, when.length))

        if matches.count == 0 {
            NSException.raise(NSInvalidArgumentException, format: "Invalid date")
        }

        if when.length == 8 {
            // Show only year/month/day
            return self.buildDateFormat().date(from: when) ?? Date()
        } else if when.length == 16 && when.characterAtIndex(15) == 'Z' {
            return self.buildDateTimeFormat().date(from: when.substringToIndex(15)) ?? Date()
        } else {
            return self.buildDateTimeFormat().date(from: when) ?? Date()
        }
    }
    @objc
    func format(_ allDay: Bool, date: Date!) -> String? {
        if date == nil {
            return nil
        }

        let format: DateFormatter! = DateFormatter()

        format.dateFormat = allDay ? "MMM d, yyyy" : "MMM d, yyyy hh:mm:ss a"

        return format.string(from: date)
    }
    @objc
    func parseDurationMS(_ durationString: String!) -> CLong {
        if durationString == nil {
            return 1
        }

        let m: NSArray! = ZX_RFC2445_DURATION.matchesInString(durationString, options: 0, range: NSMakeRange(0, durationString.length))

        if m.count == 0 {
            return 1
        }

        var durationMS: CLong = 0
        let match: NSTextCheckingResult = m[0]
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_RFC2445_DURATION_FIELD_UNITS) / MemoryLayout<CLong>.size {
            defer {
                i += 1
            }

            if match.rangeAtIndex(i + 1).location != NSNotFound {
                let fieldValue: String! = durationString.substringWithRange(match.rangeAtIndex(i + 1))

                if fieldValue != nil {
                    durationMS += ZX_RFC2445_DURATION_FIELD_UNITS[i] * fieldValue.intValue()
                }
            }
        }

        return durationMS
    }
    @objc
    func buildDateFormat() -> DateFormatter {
        let format: DateFormatter! = DateFormatter()

        format.dateFormat = "yyyyMMdd"
        format.timeZone = TimeZone.timeZoneWithAbbreviation("GMT")

        return format
    }
    @objc
    func buildDateTimeFormat() -> DateFormatter {
        let format: DateFormatter! = DateFormatter()

        format.dateFormat = "yyyyMMdd\'T\'HHmmss"

        return format
    }
    @objc
    func description() -> String? {
        return self.resultDescription
    }
}