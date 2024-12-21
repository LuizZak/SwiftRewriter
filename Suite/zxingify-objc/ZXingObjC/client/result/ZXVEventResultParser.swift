// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXCalendarParsedResult.h"
// #import "ZXResult.h"
// #import "ZXVCardResultParser.h"
// #import "ZXVEventResultParser.h"
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
/**
 * Partially implements the iCalendar format's "VEVENT" format for specifying a
 * calendar event. See RFC 2445. This supports SUMMARY, LOCATION, GEO, DTSTART and DTEND fields.
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
/**
 * Partially implements the iCalendar format's "VEVENT" format for specifying a
 * calendar event. See RFC 2445. This supports SUMMARY, LOCATION, GEO, DTSTART and DTEND fields.
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
@objc
class ZXVEventResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult {
        let rawText = ZXResultParser.massagedText(result)

        if rawText == nil {
            return nil
        }

        let vEventStart: UInt = rawText?.rangeOfString("BEGIN:VEVENT").location

        if vEventStart == NSNotFound {
            return nil
        }

        let summary = self.matchSingleVCardPrefixedField("SUMMARY", rawText: rawText, trim: true)
        let start = self.matchSingleVCardPrefixedField("DTSTART", rawText: rawText, trim: true)

        if start == nil {
            return nil
        }

        let end = self.matchSingleVCardPrefixedField("DTEND", rawText: rawText, trim: true)
        let duration = self.matchSingleVCardPrefixedField("DURATION", rawText: rawText, trim: true)
        let location = self.matchSingleVCardPrefixedField("LOCATION", rawText: rawText, trim: true)
        let organizer = self.stripMailto(self.matchSingleVCardPrefixedField("ORGANIZER", rawText: rawText, trim: true))
        let attendees = self.matchVCardPrefixedField("ATTENDEE", rawText: rawText, trim: true)

        if attendees != nil {
            var i: CInt = 0

            while i < attendees.count {
                defer {
                    i += 1
                }

                attendees[Int(i)] = self.stripMailto(attendees[Int(i)])
            }
        }

        let description = self.matchSingleVCardPrefixedField("DESCRIPTION", rawText: rawText, trim: true)
        let geoString = self.matchSingleVCardPrefixedField("GEO", rawText: rawText, trim: true)
        var latitude: CDouble
        var longitude: CDouble

        if geoString == nil {
            latitude = NAN
            longitude = NAN
        } else {
            let semicolon: UInt = geoString?.rangeOfString(";").location

            if semicolon == NSNotFound {
                return nil
            }

            latitude = geoString?.substringToIndex(semicolon).doubleValue()
            longitude = geoString?.substringFromIndex(semicolon + 1).doubleValue()
        }

        /*
        @try{return[ZXCalendarParsedResultcalendarParsedResultWithSummary:summarystartString:startendString:enddurationString:durationlocation:locationorganizer:organizerattendees:attendeesdescription:descriptionlatitude:latitudelongitude:longitude];}@catch(NSException*iae){returnnil;}
        */
    }
    @objc
    func matchSingleVCardPrefixedField(_ prefix: String!, rawText: String!, trim: Bool) -> String? {
        let values = ZXVCardResultParser.matchSingleVCardPrefixedField(prefix, rawText: rawText, trim: trim, parseFieldDivider: false)

        return (values == nil || values?.count == 0) ? nil : values?[0]
    }
    @objc
    func matchVCardPrefixedField(_ prefix: String!, rawText: String!, trim: Bool) -> NSMutableArray {
        let values = ZXVCardResultParser.matchVCardPrefixedField(prefix, rawText: rawText, trim: trim, parseFieldDivider: false)

        if values == nil || values?.count == 0 {
            return nil
        }

        let size: UInt = UInt(UInt(values?.count ?? 0))
        let result: NSMutableArray! = NSMutableArray.arrayWithCapacity(size)
        var i: CInt = 0

        while i < size {
            defer {
                i += 1
            }

            result.add(values?[Int(i)][0])
        }

        return result
    }
    @objc
    func stripMailto(_ s: String!) -> String? {
        if s != nil && (s.hasPrefix("mailto:") || s.hasPrefix("MAILTO:")) {
            s = s.substringFromIndex(7)
        }

        return s
    }
}