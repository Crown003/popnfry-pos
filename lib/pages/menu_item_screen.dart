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
              final haveVariants = doc['haveVarients'] as bool? ?? false;
              final variants = haveVariants
                  ? (doc['varients'] as List?)
                  ?.cast<Map<String, dynamic>>()
                  .length ??
                  0
                  : 0;

              return Card(
                child: ListTile(
                  title: Text(doc['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("₹${doc['price']}"),
                      if (haveVariants)
                        Text(
                          "$variants variants",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                  leading: Icon(
                    doc['isVeg'] ? Icons.eco : Icons.set_meal,
                    color: doc['isVeg'] ? Colors.green : Colors.brown,
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text("Edit"),
                        onTap: () => _showEditItemDialog(
                          context,
                          doc,
                          itemsRef,
                        ),
                      ),
                      PopupMenuItem(
                        child: const Text("Variants"),
                        onTap: () => _showVariantsDialog(context, doc),
                      ),
                      PopupMenuItem(
                        child: const Text("Delete"),
                        onTap: () => doc.reference.delete(),
                      ),
                    ],
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
    bool haveVariants = false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Item"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Item Name"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price"),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text("Veg"),
                    value: isVeg,
                    activeTrackColor: Colors.green,
                    onChanged: (v) => setState(() => isVeg = v),
                  ),
                  SwitchListTile(
                    title: const Text("Have Variants"),
                    value: haveVariants,
                    activeTrackColor: Colors.blue,
                    onChanged: (v) => setState(() => haveVariants = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("CANCEL"),
              ),
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  await itemsRef.add({
                    'name': nameCtrl.text,
                    'price': double.parse(priceCtrl.text),
                    'isVeg': isVeg,
                    'imagePlaceholder': '',
                    'haveVarients': haveVariants,
                    'varients': haveVariants ? [] : null,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item added successfully")),
                  );
                },
                child: const Text("ADD", style: TextStyle(color: Colors.green)),
              )
            ],
          );
        },
      ),
    );
  }

  void _showEditItemDialog(
      BuildContext context,
      DocumentSnapshot doc,
      CollectionReference itemsRef,
      ) {
    final nameCtrl = TextEditingController(text: doc['name']);
    final priceCtrl = TextEditingController(text: doc['price'].toString());
    bool isVeg = doc['isVeg'] as bool? ?? false;
    bool haveVariants = doc['haveVarients'] as bool? ?? false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Edit Item"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Item Name"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price"),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text("Veg"),
                    value: isVeg,
                    activeTrackColor: Colors.green,
                    onChanged: (v) => setState(() => isVeg = v),
                  ),
                  SwitchListTile(
                    title: const Text("Have Variants"),
                    value: haveVariants,
                    activeTrackColor: Colors.blue,
                    onChanged: (v) => setState(() => haveVariants = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("CANCEL"),
              ),
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  await doc.reference.update({
                    'name': nameCtrl.text,
                    'price': double.parse(priceCtrl.text),
                    'isVeg': isVeg,
                    'haveVarients': haveVariants,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item updated successfully")),
                  );
                },
                child: const Text("UPDATE", style: TextStyle(color: Colors.blue)),
              )
            ],
          );
        },
      ),
    );
  }

  void _showVariantsDialog(BuildContext context, DocumentSnapshot itemDoc) {
    final variants =
        (itemDoc['varients'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Manage Variants"),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: variants.length,
                      itemBuilder: (context, index) {
                        final variant = variants[index];
                        return Card(
                          child: ListTile(
                            title: Text(variant['name'] ?? ''),
                            subtitle: Text(
                              "${variant['symbol'] ?? ''}${variant['price'] ?? 0}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                variants.removeAt(index);
                                await itemDoc.reference
                                    .update({'varients': variants});
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        _showAddVariantDialog(context, itemDoc, variants, setState),
                    child: const Text("Add Variant"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("DONE"),
              )
            ],
          );
        },
      ),
    );
  }

  void _showAddVariantDialog(
      BuildContext context,
      DocumentSnapshot itemDoc,
      List<Map<String, dynamic>> variants,
      StateSetter setState,
      ) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final symbolCtrl = TextEditingController(text: '₹');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Variant"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Variant Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: symbolCtrl,
              decoration: const InputDecoration(labelText: "Symbol"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              variants.add({
                'name': nameCtrl.text,
                'price': int.parse(priceCtrl.text),
                'symbol': symbolCtrl.text,
              });

              await itemDoc.reference.update({'varients': variants});
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("ADD", style: TextStyle(color: Colors.green)),
          )
        ],
      ),
    );
  }
}