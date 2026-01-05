// screens/inventory_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/inventory_item_card.dart';
import '../models/inventory_item.dart';
import '../providers/inventory_provider.dart';
import '../services/firestore_service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool showForm = false;
  InventoryItem? editingItem;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load data after first frame to ensure provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInventoryData();
    });
  }

  Future<void> _loadInventoryData() async {
    try {
      print("📦 Loading inventory data from Firestore...");
      final items = await FirestoreService.fetchInventoryItems();

      if (mounted) {
        final provider = Provider.of<InventoryProvider>(context, listen: false);
        provider.setItems(items);
        setState(() {
          isLoading = false;
        });
      }
      print("✅ Inventory loaded successfully!");
    } catch (e) {
      print("❌ Error loading inventory: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void openForm({InventoryItem? item}) {
    setState(() {
      editingItem = item;
      showForm = true;
    });
  }

  void closeForm() {
    setState(() {
      showForm = false;
      editingItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: showForm ? 300 : 0,
              child: OverflowBox(
                maxHeight: 300,
                child: showForm
                    ? _AddEditForm(
                  item: editingItem,
                  onSave: () {
                    closeForm();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(editingItem == null
                            ? 'Item added successfully!'
                            : 'Item updated successfully!'),
                      ),
                    );
                  },
                  onCancel: closeForm,
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<InventoryProvider>(
              builder: (context, provider, _) {
                return TextField(
                  onChanged: provider.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search inventory...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Inventory List
          Expanded(
            child: Consumer<InventoryProvider>(
              builder: (context, provider, _) {
                final items = provider.items;
                if (items.isEmpty) {
                  return const Center(
                    child: Text('No items in inventory', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return InventoryItemCard(
                      item: item,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(item.name)));
                      },
                      onEdit: () => openForm(item: item),
                      onDelete: () {
                        provider.deleteItem(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item.name} deleted')),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (showForm) {
            closeForm();
          } else {
            openForm();
          }
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(showForm ? Icons.close : Icons.add, key: ValueKey(showForm)),
        ),
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            showForm ? 'Cancel' : (editingItem == null ? 'Add New Item' : 'Editing...'),
            key: ValueKey(showForm),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Updated Form with Firestore Integration
class _AddEditForm extends StatefulWidget {
  final InventoryItem? item;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _AddEditForm({this.item, required this.onSave, required this.onCancel});

  @override
  State<_AddEditForm> createState() => _AddEditFormState();
}

class _AddEditFormState extends State<_AddEditForm> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameCtrl;
  late final TextEditingController categoryCtrl;
  late final TextEditingController stockCtrl;
  late final TextEditingController lowThresholdCtrl;
  late final TextEditingController buyCtrl;
  late final TextEditingController sellCtrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();

    nameCtrl = TextEditingController(text: widget.item?.name ?? '');
    categoryCtrl = TextEditingController(text: widget.item?.category ?? '');
    stockCtrl = TextEditingController(text: widget.item?.stock.toString() ?? '');
    lowThresholdCtrl = TextEditingController(text: widget.item?.lowStockThreshold.toString() ?? '');
    buyCtrl = TextEditingController(text: widget.item?.purchasePrice.toStringAsFixed(0) ?? '');
    sellCtrl = TextEditingController(text: widget.item?.sellingPrice.toStringAsFixed(0) ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    categoryCtrl.dispose();
    stockCtrl.dispose();
    lowThresholdCtrl.dispose();
    buyCtrl.dispose();
    sellCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveToFirestore(InventoryItem newItem, bool isEditing) async {
    setState(() => isSaving = true);

    try {
      if (isEditing) {
        // Update existing item in Firestore
        await FirestoreService.updateInventoryItem(newItem);
        print("✅ Item updated in Firestore: ${newItem.name}");
      } else {
        // Add new item to Firestore
        await FirestoreService.addInventoryItem(newItem);
        print("✅ Item added to Firestore: ${newItem.name}");
      }

      if (mounted) {
        final provider = Provider.of<InventoryProvider>(context, listen: false);
        if (isEditing) {
          provider.updateItem(newItem);
        } else {
          provider.addItem(newItem);
        }

        widget.onSave();
      }
    } catch (e) {
      print("❌ Error saving item: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving item: $e')),
        );
      }
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing ? 'Edit Item' : 'Add New Item',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Item Name *'),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stockCtrl,
                  decoration: const InputDecoration(labelText: 'Current Stock *'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: lowThresholdCtrl,
                  decoration: const InputDecoration(labelText: 'Low Stock Alert'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: buyCtrl,
                        decoration: const InputDecoration(labelText: 'Buy Price ₹'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: sellCtrl,
                        decoration: const InputDecoration(labelText: 'Sell Price ₹'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isSaving ? null : widget.onCancel,
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () {
                          if (formKey.currentState!.validate()) {
                            final newItem = InventoryItem(
                              id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameCtrl.text.trim(),
                              category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
                              stock: int.tryParse(stockCtrl.text) ?? 0,
                              lowStockThreshold: int.tryParse(lowThresholdCtrl.text) ?? 10,
                              purchasePrice: double.tryParse(buyCtrl.text) ?? 0.0,
                              sellingPrice: double.tryParse(sellCtrl.text) ?? 0.0,
                              lastUpdated: DateTime.now(),
                            );

                            _saveToFirestore(newItem, isEditing);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isSaving
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          isEditing ? 'Update Item' : 'Save Item',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}