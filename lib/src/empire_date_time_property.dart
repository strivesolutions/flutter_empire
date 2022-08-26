part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics as a an
///ordinary dart [DateTime] object
///
///Then underlying DateTime value cannot be null
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireDateTimeProperty extends EmpireProperty<DateTime> {
  EmpireDateTimeProperty(super.value, {super.propertyName});

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

  /// The day of the week [monday]..[sunday].
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
  EmpireNullableDateTimeProperty(super.value, {super.propertyName});

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

  /// The day of the week [monday]..[sunday].
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

///Short hand helper function for initializing an [EmpireDateTimeProperty].
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireDateTimeProperty birthDate;
///
///birthDate = createDateTimeProperty(DateTime(1985, 1, 1));
///```
EmpireDateTimeProperty createDateTimeProperty(DateTime value,
    {String? propertyname}) {
  return EmpireDateTimeProperty(value, propertyName: propertyname);
}

///Short hand helper function for initializing an [EmpireNullableDateTimeProperty].
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireNullableDateTimeProperty birthDate;
///
///birthDate = createNullableDateTimeProperty();
///```
EmpireNullableDateTimeProperty createNullableDateTimeProperty(
    {DateTime? value, String? propertyName}) {
  return EmpireNullableDateTimeProperty(value, propertyName: propertyName);
}
