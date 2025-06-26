import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taste_scape1/DB/recipe_model.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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
    return recipeBox.values.isNotEmpty
        ? recipeBox.values.map((recipe) => recipe.title).toList()
        : [];
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

  
  void _showAddMealPlanBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _QuickAddMealPlanBottomSheet(
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF2045),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Meal Plans',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        const Text(
                          'Meal Types',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _mealTypeFilters.map((type) {
                            final isSelected = _selectedMealTypes.contains(type);
                            return FilterChip(
                              label: Text(type),
                              selected: isSelected,
                              selectedColor: _getMealTypeColor(type).withOpacity(0.2),
                              checkmarkColor: _getMealTypeColor(type),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    _selectedMealTypes.add(type);
                                  } else {
                                    _selectedMealTypes.remove(type);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
             
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedMealTypes = [];
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {}); 
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF2045),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Apply Filters'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return const Color(0xFFFFB74D);
      case 'Lunch':
        return const Color(0xFF4CAF50);
      case 'Dinner':
        return const Color(0xFF7E57C2);
      case 'Snack':
        return const Color(0xFFFF7043);
      default:
        return const Color(0xFFFF2045);
    }
  }

 
  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
          'My Recipes',
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
                                final mealColor = _getMealTypeColor(mealPlan.category);
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
                                                Icon(_getMealTypeIcon(mealPlan.category), color: mealColor),
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
                                                    const SizedBox(width: 8),
                                                    TextButton.icon(
                                                      icon: const Icon(Icons.visibility_outlined, size: 18),
                                                      label: const Text('View'),
                                                      onPressed: () => _showMealPlanDetails(mealPlan),
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: const Color(0xFFFF2045),
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
                  // List View
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
                              // Date header
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
                                final mealColor = _getMealTypeColor(plan.category);
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
                                                _getMealTypeIcon(plan.category),
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
                                            IconButton(
                                              icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                              onPressed: () => _showMealPlanDetails(plan),
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

class _QuickAddMealPlanBottomSheet extends StatefulWidget {
  final List<String> recipeList;
  final DateTime selectedDay;
  final VoidCallback onSave;

  const _QuickAddMealPlanBottomSheet({
    required this.recipeList,
    required this.selectedDay,
    required this.onSave,
  });

  @override
  __QuickAddMealPlanBottomSheetState createState() => __QuickAddMealPlanBottomSheetState();
}

class __QuickAddMealPlanBottomSheetState extends State<_QuickAddMealPlanBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Breakfast';
  String _mealName = '';
  List<String> _selectedRecipes = [];
  late TextEditingController _mealNameController;
  final List<String> _mealTypeFilters = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void initState() {
    super.initState();
    _mealNameController = TextEditingController();
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    super.dispose();
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return const Color(0xFFFFB74D);
      case 'Lunch':
        return const Color(0xFF4CAF50);
      case 'Dinner':
        return const Color(0xFF7E57C2);
      case 'Snack':
        return const Color(0xFFFF7043);
      default:
        return const Color(0xFFFF2045);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFF2045),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick Add Meal Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal Name
                    TextFormField(
                      controller: _mealNameController,
                      decoration: const InputDecoration(
                        labelText: 'Meal Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(Icons.restaurant_menu),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a meal name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _mealName = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Meal Category
                    const Text(
                      'Meal Category',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _mealTypeFilters.map((type) {
                        final isSelected = _selectedCategory == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          selectedColor: _getMealTypeColor(type).withOpacity(0.2),
                          checkmarkColor: _getMealTypeColor(type),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = type;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Recipes
                    const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    widget.recipeList.isEmpty
                        ? const Text(
                            'No recipes available.',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.recipeList.map((recipeTitle) {
                              final isSelected = _selectedRecipes.contains(recipeTitle);
                              return FilterChip(
                                label: Text(recipeTitle),
                                selected: isSelected,
                                selectedColor: const Color(0xFFFF2045).withOpacity(0.2),
                                checkmarkColor: const Color(0xFFFF2045),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedRecipes.add(recipeTitle);
                                    } else {
                                      _selectedRecipes.remove(recipeTitle);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final mealPlan = MealPlan(
                        mealName: _mealName,
                        category: _selectedCategory,
                        notes: '', 
                        date: DateFormat.yMMMEd().format(widget.selectedDay),
                        meals: _selectedRecipes,
                        time: TimeOfDay.now().format(context),
                      );
                      final box = Hive.box<MealPlan>('meal_plan_box');
                      await box.add(mealPlan);
                      widget.onSave();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2045),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  child: const Text(
                    'Save Meal Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyMealPlanStats extends StatelessWidget {
  final List<MealPlan> mealPlans;

  const WeeklyMealPlanStats({super.key, required this.mealPlans});

  @override
  Widget build(BuildContext context) {  
    int totalBreakfasts = mealPlans.where((plan) => plan.category == 'Breakfast').length;
    int totalLunches = mealPlans.where((plan) => plan.category == 'Lunch').length;
    int totalDinners = mealPlans.where((plan) => plan.category == 'Dinner').length;
    int totalSnacks = mealPlans.where((plan) => plan.category == 'Snack').length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Stats',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF2045),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Breakfast', totalBreakfasts, const Color(0xFFFFB74D)),
                _buildStatItem('Lunch', totalLunches, const Color(0xFF4CAF50)),
                _buildStatItem('Dinner', totalDinners, const Color(0xFF7E57C2)),
                _buildStatItem('Snack', totalSnacks, const Color(0xFFFF7043)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}