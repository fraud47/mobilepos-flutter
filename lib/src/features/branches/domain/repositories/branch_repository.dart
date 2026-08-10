import 'package:mobilepos/src/utils/typedefs.dart';
import '../entities/branch.dart';
import '../../data/models/create_branch_dto.dart';

abstract class BranchRepository {
  FutureEither<List<Branch>> getBranches(int tenantId);
  FutureEither<Branch> createBranch(int tenantId, CreateBranchDto dto);
  FutureEither<Branch> updateBranch(int branchId, CreateBranchDto dto);
  FutureEither<void> deleteBranch(int branchId);
}
