import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/providers/user_provider.dart';

class UsersDataSource extends DataTableSource {
  final UserProvider _userProvider;
  final BuildContext context;

  UsersDataSource(this._userProvider, this.context);

  @override
  DataRow getRow(int index) {
    // Jika pengguna mendekati akhir daftar, muat lebih banyak data
    if (index >= _userProvider.users.length - 2 && _userProvider.hasMore && !_userProvider.isLoading) {
      _userProvider.fetchUsers();
    }

    if (index >= _userProvider.users.length) {
      return const DataRow(cells: [DataCell(Text('')), DataCell(Text('')), DataCell(Text('')), DataCell(Text(''))]);
    }

    final UserEntity user = _userProvider.users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.name ?? 'N/A')),
        DataCell(Text(user.email ?? 'N/A')),
        DataCell(Text(user.id)),
        DataCell(IconButton(icon: const Icon(Icons.edit), onPressed: () {})),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => _userProvider.users.length + (_userProvider.hasMore ? 1 : 0);

  @override
  int get selectedRowCount => 0;
}
