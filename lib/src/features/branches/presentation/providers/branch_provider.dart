import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/branch_repository.dart';
import '../../data/repositories/branch_repository_impl.dart';
import '../../data/data_sources/impl/branch_remote_datasource_impl.dart';
import '../../data/models/create_branch_dto.dart';

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepositoryImpl(BranchRemoteDataSourceImpl.instance);
});

final branchesProvider = FutureProvider.autoDispose<List<Branch>>((ref) async {
  final session = ref.watch(sessionProvider);
  if (session.status != SessionStatus.authenticated || session.tenant == null) {
    throw Exception('No active tenant found');
  }
  
  final repository = ref.watch(branchRepositoryProvider);
  final result = await repository.getBranches(session.tenant!.id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (branches) => branches,
  );
});

class ActiveBranchNotifier extends StateNotifier<Branch?> {
  ActiveBranchNotifier() : super(null);

  void setBranch(Branch branch) {
    state = branch;
  }
}

final activeBranchProvider = StateNotifierProvider<ActiveBranchNotifier, Branch?>((ref) {
  final notifier = ActiveBranchNotifier();
  
  // Listen to branches to auto-select the first one if none is selected
  ref.listen<AsyncValue<List<Branch>>>(branchesProvider, (previous, next) {
    next.whenData((branches) {
      if (branches.isNotEmpty && notifier.state == null) {
        notifier.setBranch(branches.first);
      } else if (branches.isEmpty) {
        notifier.state = null;
      }
    });
  }, fireImmediately: true);
  
  return notifier;
});

class CreateBranchController extends StateNotifier<AsyncValue<void>> {
  final BranchRepository _repository;
  final Ref _ref;

  CreateBranchController(this._repository, this._ref) : super(const AsyncData(null));

  Future<bool> createBranch(String name, String? code, {String? address}) async {
    state = const AsyncLoading();

    final session = _ref.read(sessionProvider);
    if (session.status != SessionStatus.authenticated || session.tenant == null) {
      state = AsyncError('No active tenant found', StackTrace.current);
      return false;
    }

    final tenantId = session.tenant!.id;
    final dto = CreateBranchDto(name: name, code: code, address: address);

    final result = await _repository.createBranch(tenantId, dto);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        // Invalidate the branches list to trigger a refetch
        _ref.invalidate(branchesProvider);
        return true;
      },
    );
  }

  Future<bool> updateBranch(int branchId, String name, String? code, {String? address}) async {
    state = const AsyncLoading();
    final dto = CreateBranchDto(name: name, code: code, address: address);
    final result = await _repository.updateBranch(branchId, dto);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        _ref.invalidate(branchesProvider);
        return true;
      },
    );
  }

  Future<bool> deleteBranch(int branchId) async {
    state = const AsyncLoading();
    final result = await _repository.deleteBranch(branchId);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        _ref.invalidate(branchesProvider);
        return true;
      },
    );
  }
}

final createBranchControllerProvider =
    StateNotifierProvider.autoDispose<CreateBranchController, AsyncValue<void>>((ref) {
  final repository = ref.watch(branchRepositoryProvider);
  return CreateBranchController(repository, ref);
});
