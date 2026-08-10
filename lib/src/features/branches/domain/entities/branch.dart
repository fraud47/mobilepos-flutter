import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  final int id;
  final int tenantId;
  final String name;
  final String? code;
  final bool isActive;

  const Branch({
    required this.id,
    required this.tenantId,
    required this.name,
    this.code,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, tenantId, name, code, isActive];
}
