import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taste_scape1/db/recipe_model.dart';
import 'package:intl/intl.dart';
import 'package:taste_scape1/features/meal_plan/edit_mealplan.dart';
import 'package:taste_scape1/features/meal_plan/meal_plan_filter.dart';
import 'package:taste_scape1/features/meal_plan/meal_type.dart';
import 'package:taste_scape1/features/meal_plan/quickaddmeal_bottomsheet.dart';
import 'package:taste_scape1/features/meal_plan/view_mealplan.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> with TickerProviderStateMixin {
  late Box<MealPlan> mealPlanBox;
  late Box<Recipe> recipeBox;
  late TabController _tabController;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<String> _mealTypeFilters = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  List<String> _selectedMealTypes = [];

  bool _isLoading = true;

  List<String> get myRecipeList {
    if (recipeBox.values.isEmpty) return [];
    final List<String> titles = [];
    for (var recipe in recipeBox.values) {
      titles.add(recipe.title);
    }
    return titles;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDay = _focusedDay;

    _initBoxes();
  }

  Future<void> _initBoxes() async {
    try {
      if (!Hive.isBoxOpen('meal_plan_box')) {
        mealPlanBox = await Hive.openBox<MealPlan>('meal_plan_box');
      } else {
        mealPlanBox = Hive.box<MealPlan>('meal_plan_box');
      }

      if (!Hive.isBoxOpen('recipes')) {
        recipeBox = await Hive.openBox<Recipe>('recipes');
      } else {
        recipeBox = Hive.box<Recipe>('recipes');
      }
    } catch (e) {
      print('Error initializing boxes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MealPlan> _getEventsForDay(DateTime day) {
    final formattedDate = DateFormat.yMMMEd().format(day);
    return mealPlanBox.values.where((plan) => plan.date == formattedDate).toList();
  }

  List<MealPlan> _getFilteredMealPlans() {
    List<MealPlan> plans = mealPlanBox.values.toList();

    if (_selectedMealTypes.isNotEmpty) {
      plans = plans.where((plan) => _selectedMealTypes.contains(plan.category)).toList();
    }

    return plans;
  }

  void _showMealPlanDetails(MealPlan mealPlan) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ViewMealPlanPage(mealPlan: mealPlan),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  void _showEditMealPlanPage(MealPlan mealPlan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMealPlanPage(
          mealPlan: mealPlan,
          recipeList: myRecipeList,
          onSave: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  void _deleteMealPlan(MealPlan mealPlan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal Plan'),
        content: const Text('Are you sure you want to delete this meal plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              try {
                final box = Hive.box<MealPlan>('meal_plan_box');
                if (mealPlan.key is String || mealPlan.key is int) {
                  box.delete(mealPlan.key);
                } else {
                  // Find entry by matching fields
                  final existingIndex = box.keys.firstWhere(
                    (key) {
                      final plan = box.get(key);
                      return plan != null &&
                          plan.date == mealPlan.date &&
                          plan.mealName == mealPlan.mealName &&
                          plan.category == mealPlan.category;
                    },
                    orElse: () => null,
                  );
                  if (existingIndex != null && (existingIndex is String || existingIndex is int)) {
                    box.delete(existingIndex);
                  }
                }
              } catch (e) {
                print('Error deleting meal plan: $e');
              }
              setState(() {});
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddMealPlanBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return QuickAddMealPlanBottomSheet(
          recipeList: myRecipeList,
          selectedDay: _selectedDay ?? DateTime.now(),
          onSave: () {
            setState(() {});
          },
        );
      },
    );
  }

  void _showFilterDialog() {
    FilterBottomSheet.show(
      context: context,
      mealTypeFilters: _mealTypeFilters,
      selectedMealTypes: _selectedMealTypes,
      onApply: (selectedTypes) {
        setState(() {
          _selectedMealTypes = selectedTypes;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Meal Plans',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFFFF2045),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
              tooltip: 'Filter Meal Plans',
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _showAddMealPlanBottomSheet,
              tooltip: 'Quick Add Meal Plan',
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.calendar_month), text: 'Calendar'),
              Tab(icon: Icon(Icons.view_list), text: 'List View'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2045).withOpacity(0.05),
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          eventLoader: _getEventsForDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          calendarStyle: CalendarStyle(
                            markerDecoration: const BoxDecoration(
                              color: Color(0xFFFF2045),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: const BoxDecoration(
                              color: Color(0xFFFF2045),
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: const Color(0xFFFF2045).withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            titleCentered: true,
                            formatButtonShowsNext: false,
                            formatButtonDecoration: BoxDecoration(
                              color: const Color(0xFFFF2045).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            formatButtonTextStyle: const TextStyle(color: Color(0xFFFF2045)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: mealPlanBox.listenable(),
                          builder: (context, Box<MealPlan> box, _) {
                            final selectedEvents = _getEventsForDay(_selectedDay!);
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: selectedEvents.length,
                              itemBuilder: (context, index) {
                                final mealPlan = selectedEvents[index];
                                final mealColor = getMealTypeColor(mealPlan.category);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      onTap: () => _showMealPlanDetails(mealPlan),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: mealColor.withOpacity(0.2),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(getMealTypeIcon(mealPlan.category), color: mealColor),
                                                const SizedBox(width: 8),
                                                Text(
                                                  mealPlan.category,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: mealColor,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  mealPlan.time ?? DateFormat.jm().format(DateTime.now()),
                                                  style: TextStyle(color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  mealPlan.mealName.isNotEmpty ? mealPlan.mealName : 'No meal name',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Recipes: ${mealPlan.meals.isNotEmpty ? mealPlan.meals.join(", ") : "None"}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Notes: ${mealPlan.notes.isNotEmpty ? mealPlan.notes : "None"}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    TextButton.icon(
                                                      icon: const Icon(Icons.edit, size: 18),
                                                      label: const Text('Edit'),
                                                      onPressed: () => _showEditMealPlanPage(mealPlan),
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: const Color(0xFFFF2045),
                                                      ),
                                                    ),
                                                    TextButton.icon(
                                                      icon: const Icon(Icons.visibility_outlined, size: 18),
                                                      label: const Text('View'),
                                                      onPressed: () => _showMealPlanDetails(mealPlan),
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: const Color(0xFFFF2045),
                                                      ),
                                                    ),
                                                    TextButton.icon(
                                                      icon: const Icon(Icons.delete, size: 18),
                                                      label: const Text('Delete'),
                                                      onPressed: () => _deleteMealPlan(mealPlan),
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: mealPlanBox.listenable(),
                    builder: (context, Box<MealPlan> box, _) {
                      final filteredPlans = _getFilteredMealPlans();
                      if (filteredPlans.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.no_meals, size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text(
                                'No meal plans found',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        );
                      }
                      Map<String, List<MealPlan>> groupedPlans = {};
                      for (var plan in filteredPlans) {
                        if (!groupedPlans.containsKey(plan.date)) {
                          groupedPlans[plan.date] = [];
                        }
                        groupedPlans[plan.date]!.add(plan);
                      }
                      final sortedDates = groupedPlans.keys.toList()
                        ..sort((a, b) {
                          try {
                            return DateFormat.yMMMEd().parse(a).compareTo(DateFormat.yMMMEd().parse(b));
                          } catch (e) {
                            return a.compareTo(b);
                          }
                        });
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: sortedDates.length,
                        itemBuilder: (context, dateIndex) {
                          final date = sortedDates[dateIndex];
                          final plansForDate = groupedPlans[date]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF2045),
                                  ),
                                ),
                              ),
                              ...plansForDate.map((plan) {
                                final mealColor = getMealTypeColor(plan.category);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0, left: 8.0),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      onTap: () => _showMealPlanDetails(plan),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: mealColor.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                getMealTypeIcon(plan.category),
                                                color: mealColor,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    plan.category,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: mealColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    plan.mealName.isNotEmpty ? plan.mealName : 'No meal name',
                                                    style: const TextStyle(fontSize: 14),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Recipes: ${plan.meals.isNotEmpty ? plan.meals.join(", ") : "None"}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Time: ${plan.time ?? "Not set"}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit, size: 16),
                                                  onPressed: () => _showEditMealPlanPage(plan),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, size: 16),
                                                  onPressed: () => _deleteMealPlan(plan),
                                                  color: Colors.red,
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                                  onPressed: () => _showMealPlanDetails(plan),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              if (dateIndex < sortedDates.length - 1) const Divider(height: 24),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}