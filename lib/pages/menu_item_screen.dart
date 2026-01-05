import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const MenuItemScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final itemsRef = FirebaseFirestore.instance
        .collection('menu_categories')
        .doc(categoryId)
        .collection('items');

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, itemsRef),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: itemsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final doc = items[index];
              return Card(
                child: ListTile(
                  title: Text(doc['name']),
                  subtitle: Text("₹${doc['price']}"),
                  leading: Icon(
                    doc['isVeg'] ? Icons.eco : Icons.set_meal,
                    color: doc['isVeg'] ? Colors.green : Colors.brown,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => doc.reference.delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddItemDialog(
      BuildContext context,
      CollectionReference itemsRef,
      ) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    bool isVeg = true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Item"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Item Name"),
                ),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                ),
                SwitchListTile(
                  title: const Text("Veg"),
                  value: isVeg,
                  activeTrackColor: Colors.green,
                  onChanged: (v) => setState(() => isVeg = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await itemsRef.add({
                    'name': nameCtrl.text,
                    'price': double.parse(priceCtrl.text),
                    'isVeg': isVeg,
                    'imagePlaceholder': '',
                  });
                  Navigator.pop(context);
                },
                child: const Text("ADD", style: TextStyle(color: Colors.red)),
              )
            ],
          );
        },
      ),
    );
  }
}
