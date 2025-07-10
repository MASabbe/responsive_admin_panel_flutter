import 'package:flutter/material.dart';

class CustomPaginatedDataTable<T> extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> Function(int, int) onPageChanged;
  final int totalRows;
  final int rowsPerPage;
  final int currentPage;
  final bool sortAscending;
  final int? sortColumnIndex;
  final ValueChanged<bool?>? onSelectAll;
  final double? dataRowMinHeight;
  final double? dataRowMaxHeight;
  final double headingRowHeight;
  final double horizontalMargin;
  final double columnSpacing;
  final bool showCheckboxColumn;
  final bool showFirstLastButtons;
  final Color? headerBackgroundColor;
  final Color? headerTextColor;
  final Color? selectedRowColor;
  final bool isSearchable;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool isLoading;
  final List<Widget>? actions;

  const CustomPaginatedDataTable({
    super.key,
    required this.columns,
    required this.onPageChanged,
    required this.totalRows,
    this.rowsPerPage = 10,
    this.currentPage = 0,
    this.sortAscending = true,
    this.sortColumnIndex,
    this.onSelectAll,
    this.dataRowMinHeight,
    this.dataRowMaxHeight,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.showFirstLastButtons = true,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.selectedRowColor,
    this.isSearchable = false,
    this.searchHint,
    this.onSearchChanged,
    this.emptyWidget,
    this.loadingWidget,
    this.isLoading = false,
    this.actions,
  });

  @override
  State<CustomPaginatedDataTable<T>> createState() => _CustomPaginatedDataTableState<T>();
}

class _CustomPaginatedDataTableState<T> extends State<CustomPaginatedDataTable<T>> {
  late int _rowsPerPage;
  late int _currentPage;
  late bool _sortAscending;
  late int? _sortColumnIndex;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = widget.rowsPerPage;
    _currentPage = widget.currentPage;
    _sortAscending = widget.sortAscending;
    _sortColumnIndex = widget.sortColumnIndex;
    _searchController = TextEditingController();
  }

  @override
  void didUpdateWidget(CustomPaginatedDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      _currentPage = widget.currentPage;
    }
    if (widget.rowsPerPage != oldWidget.rowsPerPage) {
      _rowsPerPage = widget.rowsPerPage;
    }
    if (widget.sortAscending != oldWidget.sortAscending) {
      _sortAscending = widget.sortAscending;
    }
    if (widget.sortColumnIndex != oldWidget.sortColumnIndex) {
      _sortColumnIndex = widget.sortColumnIndex;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleRowsPerPageChanged(int? value) {
    if (value != null) {
      setState(() {
        _rowsPerPage = value;
        _currentPage = 0; // Reset to first page when rows per page changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataRows = widget.onPageChanged(
      _currentPage * _rowsPerPage,
      _rowsPerPage,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.isSearchable || widget.actions != null)
                  ..._buildHeader(theme),
                if (widget.isLoading && widget.loadingWidget != null)
                  widget.loadingWidget!
                else if (dataRows.isEmpty && widget.emptyWidget != null)
                  widget.emptyWidget!
                else
                  Theme(
                    data: theme.copyWith(
                      cardTheme: CardThemeData(
                        color: widget.headerBackgroundColor ?? theme.cardTheme.color,
                      ),
                    ),
                    child: PaginatedDataTable(
                      header: null,
                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: const [10, 25, 50, 100],
                      onRowsPerPageChanged: _handleRowsPerPageChanged,
                      onPageChanged: (page) => _handlePageChanged(page),
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      onSelectAll: widget.onSelectAll,
                      dataRowMinHeight: widget.dataRowMinHeight,
                      dataRowMaxHeight: widget.dataRowMaxHeight,
                      headingRowHeight: widget.headingRowHeight,
                      horizontalMargin: widget.horizontalMargin,
                      columnSpacing: widget.columnSpacing,
                      showCheckboxColumn: widget.showCheckboxColumn,
                      showFirstLastButtons: widget.showFirstLastButtons,
                      columns: widget.columns,
                      source: _CustomDataTableSource<T>(
                        dataRows,
                        _currentPage * _rowsPerPage,
                      ),
                    ),
                  ),
              ],
            ),

            // TODO: Add no data widget
            // Positioned(
            //   top: 60,
            //   child: Container(
            //     width: 1000,
            //     height: widget.headingRowHeight * 8,
            //     color: Theme.of(context).cardColor,
            //     child: Text('No Data'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHeader(ThemeData theme) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (widget.isSearchable) ...[
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.searchHint ?? 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onChanged: widget.onSearchChanged,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
            if (widget.actions != null) ...widget.actions!,
          ],
        ),
      ),
      const Divider(height: 1.0, thickness: 1.0),
    ];
  }
}

class _CustomDataTableSource<T> extends DataTableSource {
  final List<DataRow> rows;
  final int startIndex;

  _CustomDataTableSource(this.rows, this.startIndex);

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    return rows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}
