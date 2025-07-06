import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taste_scape1/db/recipe_model.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _categories = ['Vegetables', 'Fruits', 'Dairy', 'Other'];
  String _selectedFilter = 'All';
  String _selectedCategoryToAdd = 'Vegetables';
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final shoppingListBox = Hive.box<ShoppingItem>('shoppingList');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF2045), Color(0xFFE57373)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (value) => setState(() => _selectedFilter = value!),
              items: ['All', ..._categories].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(color: Colors.black87),
                  ),
                );
              }).toList(),
              underline: const SizedBox(),
              icon: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          FadeTransition(
            opacity: CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeIn,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced padding
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter item name',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () => _controller.clear(),
                        ),
                      ),
                      style: GoogleFonts.poppins(),
                      onSubmitted: (_) => _addItem(shoppingListBox),
                    ),
                  ),
                  const SizedBox(width: 8), // Reduced spacer
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategoryToAdd,
                      onChanged: (value) =>
                          setState(() => _selectedCategoryToAdd = value!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16), // Reduced padding
                      ),
                      style: GoogleFonts.poppins(color: Colors.black87),
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8), // Reduced spacer
                  SizedBox(
                    width: 40, // Constrain FAB size
                    height: 40,
                    child: FloatingActionButton(
                      onPressed: () => _addItem(shoppingListBox),
                      backgroundColor: const Color(0xFFFF2045),
                      mini: true,
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: shoppingListBox.listenable(),
              builder: (context, Box<ShoppingItem> box, _) {
                final filteredItems = _selectedFilter == 'All'
                    ? box.values.toList()
                    : box.values
                        .where((item) => item.category == _selectedFilter)
                        .toList();

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Text(
                      'No items found.',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return AnimatedList(
                  key: _listKey,
                  initialItemCount: filteredItems.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index, animation) {
                    final item = filteredItems[index];
                    return SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeOut)),
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isPurchased,
                            activeColor: const Color(0xFFFF2045),
                            onChanged: (value) {
                              setState(() {
                                item.isPurchased = value!;
                                item.save();
                              });
                            },
                          ),
                          title: Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              decoration: item.isPurchased
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isPurchased
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'Category: ${item.category}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditDialog(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(item, index),
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
    );
  }

  void _addItem(Box<ShoppingItem> box) {
    final itemName = _controller.text.trim();
    if (itemName.isNotEmpty) {
      final newItem = ShoppingItem(
        name: itemName,
        category: _selectedCategoryToAdd,
      );
      box.add(newItem).then((key) {
        _listKey.currentState?.insertItem(0);
        _controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item added: $itemName'),
            backgroundColor: const Color(0xFFFF2045),
          ),
        );
      });
    }
  }

  void _showEditDialog(ShoppingItem item) {
    final TextEditingController editController =
        TextEditingController(text: item.name);
    String selectedCategory = item.category;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Item', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: 'Update item name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) => selectedCategory = value!,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Category',
              ),
              style: GoogleFonts.poppins(),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              editController.dispose();
            },
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                item.name = editController.text.trim();
                item.category = selectedCategory;
                item.save();
              });
              Navigator.pop(context);
              editController.dispose();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF2045),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Update', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ShoppingItem item, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Item', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete this item?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          FilledButton(
            onPressed: () {
              Hive.box<ShoppingItem>('shoppingList').delete(item.key);
              _listKey.currentState?.removeItem(
                index,
                (context, animation) => SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeIn)),
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(title: Text(item.name)),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Delete', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}