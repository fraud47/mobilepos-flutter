import '../../models/branch_model.dart';
import '../../models/create_branch_dto.dart';

abstract class BranchRemoteDataSource {
  Future<List<BranchModel>> getBranches(int tenantId);
  Future<BranchModel> createBranch(int tenantId, CreateBranchDto dto);
}
