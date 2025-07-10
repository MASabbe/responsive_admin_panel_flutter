import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/providers/user_provider.dart';

class UsersDataSource extends DataTableSource {
  final UserProvider _userProvider;
  final BuildContext context;

  UsersDataSource(this._userProvider, this.context);

  @override
  DataRow getRow(int index) {
    if (index >= _userProvider.users.length) {
      if (_userProvider.isLoading) {
        return const DataRow(cells: [
          DataCell(Center(child: CircularProgressIndicator())),
          DataCell(Text('Loading...')),
          DataCell(Text('')), 
          DataCell(Text('')), 
        ]);
      }
      return const DataRow(cells: [
        DataCell(Text('')), 
        DataCell(Text('')), 
        DataCell(Text('')), 
        DataCell(Text(''))
      ]);
    }

    final UserEntity user = _userProvider.users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.name ?? 'N/A')),
        DataCell(Text(user.email ?? 'N/A')),
        DataCell(Text(user.id)),
        DataCell(Row(
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () {
              // TODO: Implement edit user
            }),
            IconButton(icon: const Icon(Icons.delete), onPressed: () {
              // TODO: Implement delete user
            }),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _userProvider.users.length;

  @override
  int get selectedRowCount => 0;
}
