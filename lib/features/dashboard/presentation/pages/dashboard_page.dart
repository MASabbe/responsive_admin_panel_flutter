import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/dashboard_card.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/custom_app_drawer.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/custom_app_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<double> _revenueData = [4.2, 7.8, 6.5, 9.5, 8.0, 10.8, 9.8, 12.5, 11.2, 14.8, 13.5, 16.2];
  final List<double> _expenseData = [3.5, 5.2, 4.8, 6.2, 5.8, 7.5, 6.8, 8.2, 7.8, 9.5, 8.8, 10.2];
  late List<Map<String, dynamic>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [
      {
        'title': 'Finalize Q2 report',
        'dueDate': 'May 10, 2025',
        'priority': 'High',
        'priorityColor': Colors.red,
        'completed': false,
      },
      {
        'title': 'Design new landing page',
        'dueDate': 'May 12, 2025',
        'priority': 'Medium',
        'priorityColor': Colors.orange,
        'completed': true,
      },
      {
        'title': 'Fix authentication bug',
        'dueDate': 'May 15, 2025',
        'priority': 'High',
        'priorityColor': Colors.red,
        'completed': false,
      },
      {
        'title': 'Onboard new client',
        'dueDate': 'May 18, 2025',
        'priority': 'Low',
        'priorityColor': Colors.green,
        'completed': false,
      },
      {
        'title': 'Prepare for team meeting',
        'dueDate': 'May 20, 2025',
        'priority': 'Low',
        'priorityColor': Colors.green,
        'completed': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Welcome Section
                  Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      return Text(
                        'Welcome back, ${auth.currentUser?.name ?? 'User'}!',
                        style: Theme.of(context).textTheme.displayMedium,
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Here\'s what\'s happening with your projects today.',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Dashboard Cards
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.2,
                    children: [
                      DashboardCard(
                        title: 'Revenue',
                        value: '\$58,945',
                        icon: Icons.attach_money,
                        color: Colors.green,
                        onTap: () {},
                      ),
                      DashboardCard(
                        title: 'Expenses',
                        value: '\$29,842',
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.red,
                        onTap: () {},
                      ),
                      DashboardCard(
                        title: 'Projects',
                        value: '124',
                        icon: Icons.work_outline,
                        color: Colors.blue,
                        onTap: () {},
                      ),
                      DashboardCard(
                        title: 'Clients',
                        value: '76',
                        icon: Icons.person_outline,
                        color: Colors.purple,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),

                  // Revenue Chart
                  _buildChartSection(context),
                  const SizedBox(height: 32.0),

                  // Recent Projects Title
                  Text('Recent Projects', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16.0),
                ]),
              ),
            ),
            _buildRecentProjectsSliver(context),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 32.0),
                  // Active Tasks Title
                  Text('Active Tasks', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16.0),
                ]),
              ),
            ),
            _buildActiveTasksSliver(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Monthly revenue and expenses for the current year',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: textColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 24.0),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 4,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < 0 || value.toInt() >= _months.length) {
                        return const SizedBox();
                      }
                      return SideTitleWidget(
                        space: 8.0,
                        meta: meta,
                        child: Text(
                          _months[value.toInt()],
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 4,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        space: 8.0,
                        meta: meta,
                        child: Text(
                          '\${value.toInt()}K',
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                    reservedSize: 40,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    width: 1,
                  ),
                  left: BorderSide(
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    width: 1,
                  ),
                ),
              ),
              minX: 0,
              maxX: 11,
              minY: 0,
              maxY: 20,
              lineBarsData: [
                // Revenue Line
                LineChartBarData(
                  spots: List.generate(
                    12,
                        (index) => FlSpot(index.toDouble(), _revenueData[index]),
                  ),
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.3),
                      Colors.green,
                    ],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.3),
                        Colors.green.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Expenses Line
                LineChartBarData(
                  spots: List.generate(
                    12,
                        (index) => FlSpot(index.toDouble(), _expenseData[index]),
                  ),
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.3),
                      Colors.red,
                    ],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.3),
                        Colors.red.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(context, 'Revenue', Colors.green),
            const SizedBox(width: 24.0),
            _buildLegendItem(context, 'Expenses', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  SliverList _buildRecentProjectsSliver(BuildContext context) {
    // Sample project data
    final List<Map<String, dynamic>> projects = [
      {
        'name': 'E-commerce App Redesign',
        'deadline': 'May 12, 2025',
        'progress': 0.75,
        'status': 'In Progress',
        'statusColor': Colors.orange,
        'members': 4,
      },
      {
        'name': 'Finance Dashboard',
        'deadline': 'May 25, 2025',
        'progress': 0.45,
        'status': 'In Progress',
        'statusColor': Colors.orange,
        'members': 3,
      },
      {
        'name': 'Social Media App',
        'deadline': 'May 30, 2025',
        'progress': 0.20,
        'status': 'Just Started',
        'statusColor': Colors.blue,
        'members': 5,
      },
      {
        'name': 'Travel Booking Platform',
        'deadline': 'May 05, 2025',
        'progress': 1.0,
        'status': 'Completed',
        'statusColor': Colors.green,
        'members': 2,
      },
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = projects[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project['name'],
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: project['statusColor'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          project['status'],
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: project['statusColor'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deadline',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7),
                                  ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              project['deadline'],
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 30, // Menambahkan tinggi eksplisit
                            child: Stack(
                              children: List.generate(
                                3,
                                (i) => Positioned(
                                  left: i * 20.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                        width: 2.0,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundImage: NetworkImage(
                                        'https://ui-avatars.com/api/?name=User${i + 1}&background=random',
                                      ),
                                    ),
                                  ),
                                ),
                              )..add(
                                  Positioned(
                                    left: 3 * 20.0,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${project['members'] - 3}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7),
                                  ),
                            ),
                            const SizedBox(height: 8.0),
                            LinearProgressIndicator(
                              value: project['progress'],
                              backgroundColor: Theme.of(context).dividerColor.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                project['progress'] == 1.0 ? Colors.green : Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                              minHeight: 8.0,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        '${(project['progress'] * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: project['progress'] == 1.0 ? Colors.green : Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        childCount: projects.length,
      ),
    );
  }

  SliverList _buildActiveTasksSliver(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () {
                      // Toggle task completion
                      setState(() {
                        tasks[index]['completed'] = !tasks[index]['completed'];
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: task['completed'] ? Theme.of(context).primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                          color: task['completed'] ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
                          width: 2.0,
                        ),
                      ),
                      child: task['completed']
                          ? const Icon(
                              Icons.check,
                              size: 16.0,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Task details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'],
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                decoration: task['completed'] ? TextDecoration.lineThrough : null,
                                color: task['completed']
                                    ? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5)
                                    : Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: task['priorityColor'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                task['priority'],
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: task['priorityColor'],
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14.0,
                              color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              task['dueDate'],
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menu button
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Show task options menu
                    },
                  ),
                ],
              ),
            ),
          );
        },
        childCount: tasks.length,
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          label: 'Projects',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_outlined),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
