// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_action_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AiAction _$AiActionFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'task':
          return TaskAction.fromJson(
            json
          );
                case 'default':
          return HabitAction.fromJson(
            json
          );
                case 'settings':
          return UpdateSettingsAction.fromJson(
            json
          );
                case 'skipHabitInstance':
          return SkipHabitInstanceAction.fromJson(
            json
          );
                case 'unknown':
          return UnknownAction.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'AiAction',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$AiAction {



  /// Serializes this AiAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiAction);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AiAction()';
}


}

/// @nodoc
class $AiActionCopyWith<$Res>  {
$AiActionCopyWith(AiAction _, $Res Function(AiAction) __);
}


/// Adds pattern-matching-related methods to [AiAction].
extension AiActionPatterns on AiAction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskAction value)?  task,TResult Function( HabitAction value)?  habit,TResult Function( UpdateSettingsAction value)?  updateSettings,TResult Function( SkipHabitInstanceAction value)?  skipHabitInstance,TResult Function( UnknownAction value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskAction() when task != null:
return task(_that);case HabitAction() when habit != null:
return habit(_that);case UpdateSettingsAction() when updateSettings != null:
return updateSettings(_that);case SkipHabitInstanceAction() when skipHabitInstance != null:
return skipHabitInstance(_that);case UnknownAction() when unknown != null:
return unknown(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskAction value)  task,required TResult Function( HabitAction value)  habit,required TResult Function( UpdateSettingsAction value)  updateSettings,required TResult Function( SkipHabitInstanceAction value)  skipHabitInstance,required TResult Function( UnknownAction value)  unknown,}){
final _that = this;
switch (_that) {
case TaskAction():
return task(_that);case HabitAction():
return habit(_that);case UpdateSettingsAction():
return updateSettings(_that);case SkipHabitInstanceAction():
return skipHabitInstance(_that);case UnknownAction():
return unknown(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskAction value)?  task,TResult? Function( HabitAction value)?  habit,TResult? Function( UpdateSettingsAction value)?  updateSettings,TResult? Function( SkipHabitInstanceAction value)?  skipHabitInstance,TResult? Function( UnknownAction value)?  unknown,}){
final _that = this;
switch (_that) {
case TaskAction() when task != null:
return task(_that);case HabitAction() when habit != null:
return habit(_that);case UpdateSettingsAction() when updateSettings != null:
return updateSettings(_that);case SkipHabitInstanceAction() when skipHabitInstance != null:
return skipHabitInstance(_that);case UnknownAction() when unknown != null:
return unknown(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String action,  String? id,  String? name,  DateTime? date,  String? startTime,  String? endTime,  String? importance,  String? note,  String? category,  bool? isDone,  bool? isDeleted,  String? defaultTaskId)?  task,TResult Function( String action,  String? id,  String? name,  List<int>? weekdays,  String? startTime,  String? endTime,  String? importance,  String? note,  String? category,  bool? isDeleted)?  habit,TResult Function( String? theme,  String? language,  bool? notificationsEnabled)?  updateSettings,TResult Function( String id,  DateTime date)?  skipHabitInstance,TResult Function( String rawResponse)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskAction() when task != null:
return task(_that.action,_that.id,_that.name,_that.date,_that.startTime,_that.endTime,_that.importance,_that.note,_that.category,_that.isDone,_that.isDeleted,_that.defaultTaskId);case HabitAction() when habit != null:
return habit(_that.action,_that.id,_that.name,_that.weekdays,_that.startTime,_that.endTime,_that.importance,_that.note,_that.category,_that.isDeleted);case UpdateSettingsAction() when updateSettings != null:
return updateSettings(_that.theme,_that.language,_that.notificationsEnabled);case SkipHabitInstanceAction() when skipHabitInstance != null:
return skipHabitInstance(_that.id,_that.date);case UnknownAction() when unknown != null:
return unknown(_that.rawResponse);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String action,  String? id,  String? name,  DateTime? date,  String? startTime,  String? endTime,  String? importance,  String? note,  String? category,  bool? isDone,  bool? isDeleted,  String? defaultTaskId)  task,required TResult Function( String action,  String? id,  String? name,  List<int>? weekdays,  String? startTime,  String? endTime,  String? importance,  String? note,  String? category,  bool? isDeleted)  habit,required TResult Function( String? theme,  String? language,  bool? notificationsEnabled)  updateSettings,required TResult Function( String id,  DateTime date)  skipHabitInstance,required TResult Function( String rawResponse)  unknown,}) {final _that = this;
switch (_that) {
case TaskAction():
return task(_that.action,_that.id,_that.name,_that.date,_that.startTime,_that.endTime,_that.importance,_that.note,_that.category,_that.isDone,_that.isDeleted,_that.defaultTaskId);case HabitAction():
return habit(_that.action,_that.id,_that.name,_that.weekdays,_that.startTime,_that.endTime,_that.importance,_that.note,_that.category,_that.isDeleted);case UpdateSettingsAction():
return updateSettings(_that.theme,_that.language,_that.notificationsEnabled);case SkipHabitInstanceAction():
return skipHabitInstance(_that.id,_that.date);case UnknownAction():
return unknown(_that.rawResponse);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String action,  String? id,  String? name,  DateTime? date,  String? startTime,  String? endTime,  String? importance,  String? note,  String? category,  bool? isDone,  bool? isDeleted,  String? defaultTaskId)?  task,TResult? Function( String action,  String? id,  String? name,  List<int>? weekdays,  String? startTime,  String? endTime,  String? importance,  String? note,  String? category,  bool? isDeleted)?  habit,TResult? Function( String? theme,  String? language,  bool? notificationsEnabled)?  updateSettings,TResult? Function( String id,  DateTime date)?  skipHabitInstance,TResult? Function( String rawResponse)?  unknown,}) {final _that = this;
switch (_that) {
case TaskAction() when task != null:
return task(_that.action,_that.id,_that.name,_that.date,_that.startTime,_that.endTime,_that.importance,_that.note,_that.category,_that.isDone,_that.isDeleted,_that.defaultTaskId);case HabitAction() when habit != null:
return habit(_that.action,_that.id,_that.name,_that.weekdays,_that.startTime,_that.endTime,_that.importance,_that.note,_that.category,_that.isDeleted);case UpdateSettingsAction() when updateSettings != null:
return updateSettings(_that.theme,_that.language,_that.notificationsEnabled);case SkipHabitInstanceAction() when skipHabitInstance != null:
return skipHabitInstance(_that.id,_that.date);case UnknownAction() when unknown != null:
return unknown(_that.rawResponse);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TaskAction implements AiAction {
  const TaskAction({required this.action, this.id, this.name, this.date, this.startTime, this.endTime, this.importance, this.note, this.category, this.isDone, this.isDeleted, this.defaultTaskId, final  String? $type}): $type = $type ?? 'task';
  factory TaskAction.fromJson(Map<String, dynamic> json) => _$TaskActionFromJson(json);

 final  String action;
// "create" | "update"
 final  String? id;
 final  String? name;
 final  DateTime? date;
 final  String? startTime;
 final  String? endTime;
 final  String? importance;
 final  String? note;
 final  String? category;
 final  bool? isDone;
 final  bool? isDeleted;
 final  String? defaultTaskId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskActionCopyWith<TaskAction> get copyWith => _$TaskActionCopyWithImpl<TaskAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskAction&&(identical(other.action, action) || other.action == action)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.importance, importance) || other.importance == importance)&&(identical(other.note, note) || other.note == note)&&(identical(other.category, category) || other.category == category)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.defaultTaskId, defaultTaskId) || other.defaultTaskId == defaultTaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,id,name,date,startTime,endTime,importance,note,category,isDone,isDeleted,defaultTaskId);

@override
String toString() {
  return 'AiAction.task(action: $action, id: $id, name: $name, date: $date, startTime: $startTime, endTime: $endTime, importance: $importance, note: $note, category: $category, isDone: $isDone, isDeleted: $isDeleted, defaultTaskId: $defaultTaskId)';
}


}

/// @nodoc
abstract mixin class $TaskActionCopyWith<$Res> implements $AiActionCopyWith<$Res> {
  factory $TaskActionCopyWith(TaskAction value, $Res Function(TaskAction) _then) = _$TaskActionCopyWithImpl;
@useResult
$Res call({
 String action, String? id, String? name, DateTime? date, String? startTime, String? endTime, String? importance, String? note, String? category, bool? isDone, bool? isDeleted, String? defaultTaskId
});




}
/// @nodoc
class _$TaskActionCopyWithImpl<$Res>
    implements $TaskActionCopyWith<$Res> {
  _$TaskActionCopyWithImpl(this._self, this._then);

  final TaskAction _self;
  final $Res Function(TaskAction) _then;

/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? action = null,Object? id = freezed,Object? name = freezed,Object? date = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? importance = freezed,Object? note = freezed,Object? category = freezed,Object? isDone = freezed,Object? isDeleted = freezed,Object? defaultTaskId = freezed,}) {
  return _then(TaskAction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,importance: freezed == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isDone: freezed == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool?,isDeleted: freezed == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool?,defaultTaskId: freezed == defaultTaskId ? _self.defaultTaskId : defaultTaskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class HabitAction implements AiAction {
  const HabitAction({required this.action, this.id, this.name, final  List<int>? weekdays, this.startTime, this.endTime, this.importance, this.note, this.category, this.isDeleted, final  String? $type}): _weekdays = weekdays,$type = $type ?? 'default';
  factory HabitAction.fromJson(Map<String, dynamic> json) => _$HabitActionFromJson(json);

 final  String action;
// "create" | "update"
 final  String? id;
// The habit UUID
 final  String? name;
 final  List<int>? _weekdays;
 List<int>? get weekdays {
  final value = _weekdays;
  if (value == null) return null;
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  String? startTime;
 final  String? endTime;
 final  String? importance;
 final  String? note;
 final  String? category;
 final  bool? isDeleted;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitActionCopyWith<HabitAction> get copyWith => _$HabitActionCopyWithImpl<HabitAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitAction&&(identical(other.action, action) || other.action == action)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._weekdays, _weekdays)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.importance, importance) || other.importance == importance)&&(identical(other.note, note) || other.note == note)&&(identical(other.category, category) || other.category == category)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,id,name,const DeepCollectionEquality().hash(_weekdays),startTime,endTime,importance,note,category,isDeleted);

@override
String toString() {
  return 'AiAction.habit(action: $action, id: $id, name: $name, weekdays: $weekdays, startTime: $startTime, endTime: $endTime, importance: $importance, note: $note, category: $category, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $HabitActionCopyWith<$Res> implements $AiActionCopyWith<$Res> {
  factory $HabitActionCopyWith(HabitAction value, $Res Function(HabitAction) _then) = _$HabitActionCopyWithImpl;
@useResult
$Res call({
 String action, String? id, String? name, List<int>? weekdays, String? startTime, String? endTime, String? importance, String? note, String? category, bool? isDeleted
});




}
/// @nodoc
class _$HabitActionCopyWithImpl<$Res>
    implements $HabitActionCopyWith<$Res> {
  _$HabitActionCopyWithImpl(this._self, this._then);

  final HabitAction _self;
  final $Res Function(HabitAction) _then;

/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? action = null,Object? id = freezed,Object? name = freezed,Object? weekdays = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? importance = freezed,Object? note = freezed,Object? category = freezed,Object? isDeleted = freezed,}) {
  return _then(HabitAction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,weekdays: freezed == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,importance: freezed == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: freezed == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UpdateSettingsAction implements AiAction {
  const UpdateSettingsAction({this.theme, this.language, this.notificationsEnabled, final  String? $type}): $type = $type ?? 'settings';
  factory UpdateSettingsAction.fromJson(Map<String, dynamic> json) => _$UpdateSettingsActionFromJson(json);

 final  String? theme;
 final  String? language;
 final  bool? notificationsEnabled;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateSettingsActionCopyWith<UpdateSettingsAction> get copyWith => _$UpdateSettingsActionCopyWithImpl<UpdateSettingsAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateSettingsActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateSettingsAction&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.language, language) || other.language == language)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,theme,language,notificationsEnabled);

@override
String toString() {
  return 'AiAction.updateSettings(theme: $theme, language: $language, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class $UpdateSettingsActionCopyWith<$Res> implements $AiActionCopyWith<$Res> {
  factory $UpdateSettingsActionCopyWith(UpdateSettingsAction value, $Res Function(UpdateSettingsAction) _then) = _$UpdateSettingsActionCopyWithImpl;
@useResult
$Res call({
 String? theme, String? language, bool? notificationsEnabled
});




}
/// @nodoc
class _$UpdateSettingsActionCopyWithImpl<$Res>
    implements $UpdateSettingsActionCopyWith<$Res> {
  _$UpdateSettingsActionCopyWithImpl(this._self, this._then);

  final UpdateSettingsAction _self;
  final $Res Function(UpdateSettingsAction) _then;

/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? theme = freezed,Object? language = freezed,Object? notificationsEnabled = freezed,}) {
  return _then(UpdateSettingsAction(
theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,notificationsEnabled: freezed == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SkipHabitInstanceAction implements AiAction {
  const SkipHabitInstanceAction({required this.id, required this.date, final  String? $type}): $type = $type ?? 'skipHabitInstance';
  factory SkipHabitInstanceAction.fromJson(Map<String, dynamic> json) => _$SkipHabitInstanceActionFromJson(json);

 final  String id;
// The habit UUID (default_task_id)
 final  DateTime date;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkipHabitInstanceActionCopyWith<SkipHabitInstanceAction> get copyWith => _$SkipHabitInstanceActionCopyWithImpl<SkipHabitInstanceAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkipHabitInstanceActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipHabitInstanceAction&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date);

@override
String toString() {
  return 'AiAction.skipHabitInstance(id: $id, date: $date)';
}


}

/// @nodoc
abstract mixin class $SkipHabitInstanceActionCopyWith<$Res> implements $AiActionCopyWith<$Res> {
  factory $SkipHabitInstanceActionCopyWith(SkipHabitInstanceAction value, $Res Function(SkipHabitInstanceAction) _then) = _$SkipHabitInstanceActionCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date
});




}
/// @nodoc
class _$SkipHabitInstanceActionCopyWithImpl<$Res>
    implements $SkipHabitInstanceActionCopyWith<$Res> {
  _$SkipHabitInstanceActionCopyWithImpl(this._self, this._then);

  final SkipHabitInstanceAction _self;
  final $Res Function(SkipHabitInstanceAction) _then;

/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,}) {
  return _then(SkipHabitInstanceAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UnknownAction implements AiAction {
  const UnknownAction({required this.rawResponse, final  String? $type}): $type = $type ?? 'unknown';
  factory UnknownAction.fromJson(Map<String, dynamic> json) => _$UnknownActionFromJson(json);

 final  String rawResponse;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownActionCopyWith<UnknownAction> get copyWith => _$UnknownActionCopyWithImpl<UnknownAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnknownActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownAction&&(identical(other.rawResponse, rawResponse) || other.rawResponse == rawResponse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rawResponse);

@override
String toString() {
  return 'AiAction.unknown(rawResponse: $rawResponse)';
}


}

/// @nodoc
abstract mixin class $UnknownActionCopyWith<$Res> implements $AiActionCopyWith<$Res> {
  factory $UnknownActionCopyWith(UnknownAction value, $Res Function(UnknownAction) _then) = _$UnknownActionCopyWithImpl;
@useResult
$Res call({
 String rawResponse
});




}
/// @nodoc
class _$UnknownActionCopyWithImpl<$Res>
    implements $UnknownActionCopyWith<$Res> {
  _$UnknownActionCopyWithImpl(this._self, this._then);

  final UnknownAction _self;
  final $Res Function(UnknownAction) _then;

/// Create a copy of AiAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rawResponse = null,}) {
  return _then(UnknownAction(
rawResponse: null == rawResponse ? _self.rawResponse : rawResponse // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
