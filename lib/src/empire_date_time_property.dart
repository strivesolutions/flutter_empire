part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics as a an
///ordinary dart [DateTime] object
///
///Then underlying DateTime value cannot be null
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireDateTimeProperty extends EmpireProperty<DateTime> {
  EmpireDateTimeProperty(super.value, {super.propertyName})
      : super(isPrimitiveType: true);

  ///Factory constructor for initializing an [EmpireDateTimeProperty] to the current Date/Time.
  ///
  ///See [EmpireProperty] for [propertyName] usages.
  ///
  ///## Example
  ///
  ///```dart
  ///final today = EmpireDateTimeProperty.now();
  ///```
  factory EmpireDateTimeProperty.now({String? propertyName}) {
    return EmpireDateTimeProperty(DateTime.now(), propertyName: propertyName);
  }

  /// Constructs a new [EmpireDateTimeProperty] instance based on [formattedString].
  ///
  //////See [EmpireProperty] for [propertyName] usages.
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// The accepted inputs are currently:
  ///
  /// * A date: A signed four-to-six digit year, two digit month and
  ///   two digit day, optionally separated by `-` characters.
  ///   Examples: "19700101", "-0004-12-24", "81030-04-01".
  /// * An optional time part, separated from the date by either `T` or a space.
  ///   The time part is a two digit hour,
  ///   then optionally a two digit minutes value,
  ///   then optionally a two digit seconds value, and
  ///   then optionally a '.' or ',' followed by at least a one digit
  ///   second fraction.
  ///   The minutes and seconds may be separated from the previous parts by a
  ///   ':'.
  ///   Examples: "12", "12:30:24.124", "12:30:24,124", "123010.50".
  /// * An optional time-zone offset part,
  ///   possibly separated from the previous by a space.
  ///   The time zone is either 'z' or 'Z', or it is a signed two digit hour
  ///   part and an optional two digit minute part. The sign must be either
  ///   "+" or "-", and cannot be omitted.
  ///   The minutes may be separated from the hours by a ':'.
  ///   Examples: "Z", "-10", "+01:30", "+1130".
  ///
  /// This includes the output of both [toString] and [toIso8601String], which
  /// will be parsed back into a `DateTime` object with the same time as the
  /// original.
  ///
  /// The result is always in either local time or UTC.
  /// If a time zone offset other than UTC is specified,
  /// the time is converted to the equivalent UTC time.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27 13:27:00.123456789z"`
  /// * `"2012-02-27 13:27:00,123456789z"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14Z"`
  /// * `"2012-02-27T14+00:00"`
  /// * `"-123450101 00:00:00 Z"`: in the year -12345.
  /// * `"2002-02-27T14:00:00-0500"`: Same as `"2002-02-27T19:00:00Z"`
  ///
  /// This method accepts out-of-range component values and interprets
  /// them as overflows into the next larger component.
  /// For example, "2020-01-42" will be parsed as 2020-02-11, because
  /// the last valid date in that month is 2020-01-31, so 42 days is
  /// interpreted as 31 days of that month plus 11 days into the next month.
  ///
  /// To detect and reject invalid component values, use
  /// [DateFormat.parseStrict](https://pub.dev/documentation/intl/latest/intl/DateFormat/parseStrict.html)
  /// from the [intl](https://pub.dev/packages/intl) package.
  static EmpireDateTimeProperty parse(String formattedString,
      {String? propertyName}) {
    final dateTime = DateTime.parse(formattedString);

    return EmpireDateTimeProperty(dateTime, propertyName: propertyName);
  }

  /// The year.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.year); // 1969
  /// ```
  int get year => _value.year;

  /// The month `[1..12]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int get month => _value.month;

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.day); // 20
  /// ```
  int get day => _value.day;

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.hour); // 20
  /// ```
  int get hour => _value.hour;

  /// The minute `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.minute); // 18
  /// ```
  int get minute => _value.minute;

  /// The second `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.second); // 4
  /// ```
  int get second => _value.second;

  /// The number of milliseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// This value is independent of the time zone.
  int get millisecondsSinceEpoch => _value.millisecondsSinceEpoch;

  /// The number of microseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// This value is independent of the time zone.
  int get microsecondsSinceEpoch => _value.microsecondsSinceEpoch;

  /// The microsecond `[0...999]`.
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.microsecond); // 567
  /// ```
  int get microsecond => _value.microsecond;

  /// The millisecond `[0...999]`.
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.millisecond); // 234
  /// ```
  int get millisecond => _value.millisecond;

  /// The day of the week monday..sunday.
  ///
  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.weekday); // 7
  /// assert(moonLanding.weekday == DateTime.sunday);
  /// ```
  int get weekday => _value.weekday;

  /// True if this [DateTime] is set to UTC time.
  ///
  /// ```dart
  /// final dDay = DateTime.utc(1944, 6, 6);
  /// print(dDay.isUtc); // true
  ///
  /// final local = DateTime(1944, 6, 6);
  /// print(local.isUtc); // false
  /// ```
  bool get isUtc => _value.isUtc;

  /// The time zone name.
  ///
  /// This value is provided by the operating system and may be an
  /// abbreviation or a full name.
  String get timeZoneName => _value.timeZoneName;

  /// The time zone offset, which
  /// is the difference between local time and UTC.
  ///
  /// The offset is positive for time zones east of UTC.
  ///
  /// Note, that JavaScript, Python and C return the difference between UTC and
  /// local time. Java, C# and Ruby return the difference between local time and
  /// UTC.
  Duration get timeZoneOffset => _value.timeZoneOffset;

  /// Returns true if [this] occurs before [other].
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final earlier = now.subtract(const Duration(seconds: 5));
  /// print(earlier.isBefore(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(earlier.isBefore(now.toUtc())); // true
  /// print(earlier.toUtc().isBefore(now)); // true
  ///
  /// print(!now.toUtc().isBefore(now)); // true
  /// print(!now.isBefore(now.toUtc())); // true
  /// ```
  bool isBefore(DateTime other) => _value.isBefore(other);

  /// Returns true if [this] occurs after [other].
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(later.isAfter(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(later.isAfter(now.toUtc())); // true
  /// print(later.toUtc().isAfter(now)); // true
  ///
  /// print(!now.toUtc().isAfter(now)); // true
  /// print(!now.isAfter(now.toUtc())); // true
  /// ```
  bool isAfter(DateTime other) => _value.isAfter(other);

  /// Returns true if [this] occurs at the same moment as [other].
  ///
  /// The comparison is independent of whether the time is in UTC or in the local
  /// time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(!later.isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(!later.isAtSameMomentAs(now.toUtc())); // true
  /// print(!later.toUtc().isAtSameMomentAs(now)); // true
  ///
  /// print(now.toUtc().isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now.toUtc())); // true
  /// ```
  bool isAtSameMomentAs(DateTime other) => _value.isAtSameMomentAs(other);

  /// Compares this DateTime object to [other],
  /// returning zero if the values are equal.
  ///
  /// A [compareTo] function returns:
  ///  * a negative value if this DateTime [isBefore] [other].
  ///  * `0` if this DateTime [isAtSameMomentAs] [other], and
  ///  * a positive value otherwise (when this DateTime [isAfter] [other]).
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final future = now.add(const Duration(days: 2));
  /// final past = now.subtract(const Duration(days: 2));
  /// final newDate = now.toUtc();
  ///
  /// print(now.compareTo(future)); // -1
  /// print(now.compareTo(past)); // 1
  /// print(now.compareTo(newDate)); // 0
  /// ```
  int compareTo(DateTime other) => _value.compareTo(other);

  /// Returns this DateTime value in the local time zone.
  ///
  /// Returns [this] if it is already in the local time zone.
  DateTime toLocal() => _value.toLocal();

  /// Returns this DateTime value in the UTC time zone.
  DateTime toUtc() => _value.toUtc();

  /// Returns an ISO-8601 full-precision extended format representation.
  ///
  /// The format is `yyyy-MM-ddTHH:mm:ss.mmmuuuZ` for UTC time, and
  /// `yyyy-MM-ddTHH:mm:ss.mmmuuu` (no trailing "Z") for local/non-UTC time,
  /// where:
  ///
  /// * `yyyy` is a, possibly negative, four digit representation of the year,
  ///   if the year is in the range -9999 to 9999,
  ///   otherwise it is a signed six digit representation of the year.
  /// * `MM` is the month in the range 01 to 12,
  /// * `dd` is the day of the month in the range 01 to 31,
  /// * `HH` are hours in the range 00 to 23,
  /// * `mm` are minutes in the range 00 to 59,
  /// * `ss` are seconds in the range 00 to 59 (no leap seconds),
  /// * `mmm` are milliseconds in the range 000 to 999, and
  /// * `uuu` are microseconds in the range 001 to 999. If [microsecond] equals
  ///   0, then this part is omitted.
  ///
  /// The resulting string can be parsed back using [parse].
  /// ```dart
  /// final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
  /// final isoDate = moonLanding.toIso8601String();
  /// print(isoDate); // 1969-07-20T20:18:04.000Z
  /// ```
  String toIso8601String() => _value.toIso8601String();

  /// Returns a new [DateTime] instance with [duration] added to [this].
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysFromNow = today.add(const Duration(days: 50));
  /// ```
  DateTime add(Duration duration) => _value.add(duration);

  /// Returns a new [DateTime] instance with [duration] subtracted from [this].
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysAgo = today.subtract(const Duration(days: 50));
  /// ```
  DateTime subtract(Duration duration) => _value.subtract(duration);

  // Returns a [Duration] with the difference when subtracting [other] from
  /// [this].
  ///
  /// The returned [Duration] will be negative if [other] occurs after [this].
  ///
  /// ```dart
  /// final berlinWallFell = DateTime.utc(1989, DateTime.november, 9);
  /// final dDay = DateTime.utc(1944, DateTime.june, 6);
  ///
  /// final difference = berlinWallFell.difference(dDay);
  /// print(difference.inDays); // 16592
  /// ```
  Duration difference(DateTime other) => _value.difference(other);
}

///An [EmpireProperty] with similar characteristics as a an
///ordinary dart bool object.
///
///Then underlying bool value *CAN* be null
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireNullableDateTimeProperty extends EmpireProperty<DateTime?> {
  EmpireNullableDateTimeProperty({DateTime? value, super.propertyName})
      : super(value, isPrimitiveType: true);

  ///Factory constructor for initializing an [EmpireNullableDateTimeProperty] to the current Date/Time.
  ///
  ///See [EmpireProperty] for [propertyName] usages.
  ///
  ///## Example
  ///
  ///```dart
  ///final today = EmpireDateTimeProperty.now();
  ///```
  factory EmpireNullableDateTimeProperty.now({String? propertyName}) {
    return EmpireNullableDateTimeProperty(
      value: DateTime.now(),
      propertyName: propertyName,
    );
  }

  /// Constructs a new [EmpireNullableDateTimeProperty] instance based on [formattedString].
  ///
  //////See [EmpireProperty] for [propertyName] usages.
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// The accepted inputs are currently:
  ///
  /// * A date: A signed four-to-six digit year, two digit month and
  ///   two digit day, optionally separated by `-` characters.
  ///   Examples: "19700101", "-0004-12-24", "81030-04-01".
  /// * An optional time part, separated from the date by either `T` or a space.
  ///   The time part is a two digit hour,
  ///   then optionally a two digit minutes value,
  ///   then optionally a two digit seconds value, and
  ///   then optionally a '.' or ',' followed by at least a one digit
  ///   second fraction.
  ///   The minutes and seconds may be separated from the previous parts by a
  ///   ':'.
  ///   Examples: "12", "12:30:24.124", "12:30:24,124", "123010.50".
  /// * An optional time-zone offset part,
  ///   possibly separated from the previous by a space.
  ///   The time zone is either 'z' or 'Z', or it is a signed two digit hour
  ///   part and an optional two digit minute part. The sign must be either
  ///   "+" or "-", and cannot be omitted.
  ///   The minutes may be separated from the hours by a ':'.
  ///   Examples: "Z", "-10", "+01:30", "+1130".
  ///
  /// This includes the output of both [toString] and [toIso8601String], which
  /// will be parsed back into a `DateTime` object with the same time as the
  /// original.
  ///
  /// The result is always in either local time or UTC.
  /// If a time zone offset other than UTC is specified,
  /// the time is converted to the equivalent UTC time.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27 13:27:00.123456789z"`
  /// * `"2012-02-27 13:27:00,123456789z"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14Z"`
  /// * `"2012-02-27T14+00:00"`
  /// * `"-123450101 00:00:00 Z"`: in the year -12345.
  /// * `"2002-02-27T14:00:00-0500"`: Same as `"2002-02-27T19:00:00Z"`
  ///
  /// This method accepts out-of-range component values and interprets
  /// them as overflows into the next larger component.
  /// For example, "2020-01-42" will be parsed as 2020-02-11, because
  /// the last valid date in that month is 2020-01-31, so 42 days is
  /// interpreted as 31 days of that month plus 11 days into the next month.
  ///
  /// To detect and reject invalid component values, use
  /// [DateFormat.parseStrict](https://pub.dev/documentation/intl/latest/intl/DateFormat/parseStrict.html)
  /// from the [intl](https://pub.dev/packages/intl) package.
  static EmpireNullableDateTimeProperty parse(String formattedString,
      {String? propertyName}) {
    final dateTime = DateTime.parse(formattedString);

    return EmpireNullableDateTimeProperty(
      value: dateTime,
      propertyName: propertyName,
    );
  }

  // Constructs a new [EmpireNullableDateTimeProperty] instance based on [formattedString].
  ///
  /// Works like [parse] except that this function returns `null`
  /// where [parse] would throw a [FormatException].
  static EmpireNullableDateTimeProperty tryParse(String formattedString,
      {String? propertyName}) {
    final dateTime = DateTime.tryParse(formattedString);
    return EmpireNullableDateTimeProperty(
      value: dateTime,
      propertyName: propertyName,
    );
  }

  ///Sets the value to null
  void setNull({bool notifyChange = true}) =>
      super.set(null, notifyChange: notifyChange);

  /// The year.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.year); // 1969
  /// ```
  int? get year => _value?.year;

  /// The month `[1..12]`.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int? get month => _value?.month;

  /// The day of the month `[1..31]`.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.day); // 20
  /// ```
  int? get day => _value?.day;

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.hour); // 20
  /// ```
  int? get hour => _value?.hour;

  /// The minute `[0...59]`.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.minute); // 18
  /// ```
  int? get minute => _value?.minute;

  /// The second `[0...59]`.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.second); // 4
  /// ```
  int? get second => _value?.second;

  /// The number of milliseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// Returns null if [this] is null
  ///
  /// This value is independent of the time zone.
  int? get millisecondsSinceEpoch => _value?.millisecondsSinceEpoch;

  /// The number of microseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// Returns null if [this] is null
  ///
  /// This value is independent of the time zone.
  int? get microsecondsSinceEpoch => _value?.microsecondsSinceEpoch;

  /// The microsecond `[0...999]`.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.microsecond); // 567
  /// ```
  int? get microsecond => _value?.microsecond;

  /// The millisecond `[0...999]`.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.millisecond); // 234
  /// ```
  int? get millisecond => _value?.millisecond;

  /// The day of the week monday..sunday.
  ///
  /// Returns null if [this] is null
  ///
  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.weekday); // 7
  /// assert(moonLanding.weekday == DateTime.sunday);
  /// ```
  int? get weekday => _value?.weekday;

  /// True if this [DateTime] is set to UTC time.
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final dDay = DateTime.utc(1944, 6, 6);
  /// print(dDay.isUtc); // true
  ///
  /// final local = DateTime(1944, 6, 6);
  /// print(local.isUtc); // false
  /// ```
  bool? get isUtc => _value?.isUtc;

  /// The time zone name.
  ///
  /// Returns null if [this] is null
  ///
  /// This value is provided by the operating system and may be an
  /// abbreviation or a full name.
  String? get timeZoneName => _value?.timeZoneName;

  /// The time zone offset, which
  /// is the difference between local time and UTC.
  ///
  /// Returns null if [this] is null
  ///
  /// The offset is positive for time zones east of UTC.
  ///
  /// Note, that JavaScript, Python and C return the difference between UTC and
  /// local time. Java, C# and Ruby return the difference between local time and
  /// UTC.
  Duration? get timeZoneOffset => _value?.timeZoneOffset;

  /// Returns true if [this] occurs before [other].
  ///
  /// Returns false if [this] is null
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final earlier = now.subtract(const Duration(seconds: 5));
  /// print(earlier.isBefore(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(earlier.isBefore(now.toUtc())); // true
  /// print(earlier.toUtc().isBefore(now)); // true
  ///
  /// print(!now.toUtc().isBefore(now)); // true
  /// print(!now.isBefore(now.toUtc())); // true
  /// ```
  bool isBefore(DateTime other) => _value?.isBefore(other) ?? false;

  /// Returns true if [this] occurs after [other].
  ///
  /// Returns false if [this] is null
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(later.isAfter(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(later.isAfter(now.toUtc())); // true
  /// print(later.toUtc().isAfter(now)); // true
  ///
  /// print(!now.toUtc().isAfter(now)); // true
  /// print(!now.isAfter(now.toUtc())); // true
  /// ```
  bool isAfter(DateTime other) => _value?.isAfter(other) ?? false;

  /// Returns true if [this] occurs at the same moment as [other].
  ///
  /// Returns false if [this] is null
  ///
  /// The comparison is independent of whether the time is in UTC or in the local
  /// time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(!later.isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(!later.isAtSameMomentAs(now.toUtc())); // true
  /// print(!later.toUtc().isAtSameMomentAs(now)); // true
  ///
  /// print(now.toUtc().isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now.toUtc())); // true
  /// ```
  bool isAtSameMomentAs(DateTime other) =>
      _value?.isAtSameMomentAs(other) ?? false;

  /// Compares this DateTime object to [other],
  /// returning zero if the values are equal.
  ///
  /// Returns -1 if [this] is null
  ///
  /// A [compareTo] function returns:
  ///  * a negative value if this DateTime [isBefore] [other].
  ///  * `0` if this DateTime [isAtSameMomentAs] [other], and
  ///  * a positive value otherwise (when this DateTime [isAfter] [other]).
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final future = now.add(const Duration(days: 2));
  /// final past = now.subtract(const Duration(days: 2));
  /// final newDate = now.toUtc();
  ///
  /// print(now.compareTo(future)); // -1
  /// print(now.compareTo(past)); // 1
  /// print(now.compareTo(newDate)); // 0
  /// ```
  int compareTo(DateTime other) => _value?.compareTo(other) ?? -1;

  /// Returns this DateTime value in the local time zone.
  ///
  /// Returns null if [this] is null
  ///
  /// Returns [this] if it is already in the local time zone.
  DateTime? toLocal() => _value?.toLocal();

  /// Returns this DateTime value in the UTC time zone.
  ///
  /// Returns null if [this] is null
  DateTime? toUtc() => _value?.toUtc();

  /// Returns an ISO-8601 full-precision extended format representation.
  ///
  /// Returns null if [this] is null
  ///
  /// The format is `yyyy-MM-ddTHH:mm:ss.mmmuuuZ` for UTC time, and
  /// `yyyy-MM-ddTHH:mm:ss.mmmuuu` (no trailing "Z") for local/non-UTC time,
  /// where:
  ///
  /// * `yyyy` is a, possibly negative, four digit representation of the year,
  ///   if the year is in the range -9999 to 9999,
  ///   otherwise it is a signed six digit representation of the year.
  /// * `MM` is the month in the range 01 to 12,
  /// * `dd` is the day of the month in the range 01 to 31,
  /// * `HH` are hours in the range 00 to 23,
  /// * `mm` are minutes in the range 00 to 59,
  /// * `ss` are seconds in the range 00 to 59 (no leap seconds),
  /// * `mmm` are milliseconds in the range 000 to 999, and
  /// * `uuu` are microseconds in the range 001 to 999. If [microsecond] equals
  ///   0, then this part is omitted.
  ///
  /// The resulting string can be parsed back using [parse].
  /// ```dart
  /// final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
  /// final isoDate = moonLanding.toIso8601String();
  /// print(isoDate); // 1969-07-20T20:18:04.000Z
  /// ```
  String? toIso8601String() => _value?.toIso8601String();

  /// Returns a new [DateTime] instance with [duration] added to [this].
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysFromNow = today.add(const Duration(days: 50));
  /// ```
  DateTime? add(Duration duration) => _value?.add(duration);

  /// Returns a new [DateTime] instance with [duration] subtracted from [this].
  ///
  /// Returns null if [this] is null
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysAgo = today.subtract(const Duration(days: 50));
  /// ```
  DateTime? subtract(Duration duration) => _value?.subtract(duration);

  // Returns a [Duration] with the difference when subtracting [other] from
  /// [this].
  ///
  /// Returns null if [this] is null
  ///
  /// The returned [Duration] will be negative if [other] occurs after [this].
  ///
  /// ```dart
  /// final berlinWallFell = DateTime.utc(1989, DateTime.november, 9);
  /// final dDay = DateTime.utc(1944, DateTime.june, 6);
  ///
  /// final difference = berlinWallFell.difference(dDay);
  /// print(difference.inDays); // 16592
  /// ```
  Duration? difference(DateTime other) => _value?.difference(other);
}
