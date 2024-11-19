import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<String> categories = [
    'SUV',
    'Sedan',
    'Luxury',
    'Electric',
    'Sports'
  ]; // Example categories
  bool isAddingCategory = false;
  String? newCategory;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Categories'),
        actions: [
          if (!isAddingCategory)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  isAddingCategory = true;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // If adding category, show form, else show category list
            if (isAddingCategory) _buildAddCategoryForm(),
            if (!isAddingCategory) _buildCategoryList(),
          ],
        ),
      ),
    );
  }

  // Widget to show category list
  Widget _buildCategoryList() {
    return Expanded(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              title: Text(categories[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editCategory(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCategory(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget to show the form to add a new category
  Widget _buildAddCategoryForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => newCategory = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveCategory,
            child: Text('Save Category'),
          ),
        ],
      ),
    );
  }

  // Method to save new category
  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (newCategory != null && newCategory!.isNotEmpty) {
        setState(() {
          categories.add(newCategory!);
          isAddingCategory = false; // Hide the form after saving
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Category Added')));
      }
    }
  }

  // Method to edit a category (For now it allows just changing the name)
  void _editCategory(int index) {
    setState(() {
      isAddingCategory = true;
      newCategory = categories[index];
    });
  }

  // Method to delete a category
  void _deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Category Deleted')));
  }
}