import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TaskState extends Equatable {
  final DateTime? selectedDate;
  const TaskState({this.selectedDate});

  @override
  List<Object?> get props => [selectedDate];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {
  const TaskLoading({super.selectedDate});
}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  const TaskLoaded(this.tasks, {required DateTime selectedDate})
    : super(selectedDate: selectedDate);

  @override
  List<Object?> get props => [tasks, selectedDate];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message, {super.selectedDate});

  @override
  List<Object?> get props => [message, selectedDate];
}

class FutureTasksLoaded extends TaskState {
  final List<TaskModel> tasks;

  const FutureTasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
