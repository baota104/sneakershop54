part of 'app_cubit.dart';
// class nay giu state cua ung dung
class AppState extends Equatable {
  final AuthenticationStatus status;

  const AppState({
    this.status = AuthenticationStatus.unknow,
});

  AppState copyWith({
    final AuthenticationStatus? status,
  }) {
    return AppState(
      status: status ?? this.status,
    );
  }

  List<Object> get props => [
    status
  ];
}
