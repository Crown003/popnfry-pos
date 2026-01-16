// File: lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/menu_category.dart';
import '../models/table.dart';
import '../models/inventory_item.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ FETCH TABLES ============
  static Future<List<TableData>> fetchTables() async {
    try {
      print("📋 Fetching tables from Firestore...");
      final snapshot = await _firestore.collection('tables').get();

      List<TableData> tables = [];
      for (var doc in snapshot.docs) {
        try {
          int number = doc['number'] as int? ?? 0;
          String statusStr = doc['status'] as String? ?? 'free';

          tables.add(TableData(
            number: number,
            status: statusStr == 'occupied' ? Status.occupied : Status.free,
          ));
        } catch (e) {
          print("Error parsing table: $e");
        }
      }

      print("✅ Fetched ${tables.length} tables");
      return tables;
    } catch (e) {
      print("❌ Error fetching tables: $e");
      return [];
    }
  }

  // ============ FETCH MENU CATEGORIES ============
  static Future<List<MenuCategory>> fetchMenuCategories() async {
    try {
      print("🍕 Fetching menu categories from Firestore...");
      final snapshot = await _firestore.collection('menu_categories').get();

      List<MenuCategory> categories = [];

      for (var categoryDoc in snapshot.docs) {
        try {
          String categoryName = categoryDoc['name'] as String? ?? 'Unknown';
          String iconName = categoryDoc['icon'] as String? ?? 'restaurant';

          // Fetch items for this category
          final itemsSnapshot = await categoryDoc.reference.collection('items').get();

          List<MenuItem> items = [];
          for (var itemDoc in itemsSnapshot.docs) {
            try {
              String itemName = itemDoc['name'] as String? ?? 'Unknown';
              double price = (itemDoc['price'] as num?)?.toDouble() ?? 0.0;
              String imagePlaceholder = itemDoc['imagePlaceholder'] as String? ?? '';
              bool isVeg = itemDoc['isVeg'] as bool? ?? false;
              bool haveVariants = itemDoc['haveVarients']?? false;

              List<Variant>? variants = haveVariants
                  ? (itemDoc['varients'] as List?)
                  ?.map((v) => Variant.fromMap(v as Map<String, dynamic>))
                  .toList()
                  : null;

              items.add(
                MenuItem(
                  name: itemName ?? 'Unknown',
                  price: price,
                  imagePlaceholder:imagePlaceholder,
                  isVeg: isVeg,
                  haveVariants: haveVariants,
                  variants: variants,
                ),
              );
            } catch (e) {
              print("Error parsing item: $e");
            }
          }
          categories.add(MenuCategory(
            name: categoryName,
            icon: _getIconFromString(iconName),
            items: items,
          ));
          print("  ✓ $categoryName (${items.length} items)");
        } catch (e) {
          print("Error parsing category: $e");
        }
      }

      print("✅ Fetched ${categories.length} categories");
      return categories;
    } catch (e) {
      print("❌ Error fetching menu categories: $e");
      return [];
    }
  }

  // ============ FETCH INVENTORY ============
  static Future<List<InventoryItem>> fetchInventoryItems() async {
    try {
      print("📦 Fetching inventory from Firestore...");
      final snapshot = await _firestore.collection('inventory').get();

      List<InventoryItem> items = [];
      for (var doc in snapshot.docs) {
        try {
          String name = doc['name'] as String? ?? 'Unknown';
          String category = doc['category'] as String? ?? 'Uncategorized';
          int stock = doc['stock'] as int? ?? 0;
          int lowStockThreshold = doc['lowStockThreshold'] as int? ?? 0;
          double purchasePrice = (doc['purchasePrice'] as num?)?.toDouble() ?? 0.0;
          double sellingPrice = (doc['sellingPrice'] as num?)?.toDouble() ?? 0.0;

          items.add(InventoryItem(
            id: doc.id,
            name: name,
            category: category,
            stock: stock,
            lowStockThreshold: lowStockThreshold,
            purchasePrice: purchasePrice,
            sellingPrice: sellingPrice,
          ));

          print("  ✓ $name");
        } catch (e) {
          print("Error parsing inventory item: $e");
        }
      }

      print("✅ Fetched ${items.length} inventory items");
      return items;
    } catch (e) {
      print("❌ Error fetching inventory: $e");
      return [];
    }
  }

  // ============ UPDATE TABLE STATUS ============
  static Future<void> updateTableStatus(int tableNumber, Status status) async {
    try {
      String statusStr = status == Status.occupied ? 'occupied' : 'free';
      await _firestore
          .collection('tables')
          .doc('table_$tableNumber')
          .update({'status': statusStr});

      print("✅ Updated table $tableNumber status to $statusStr");
    } catch (e) {
      print("❌ Error updating table status: $e");
    }
  }

  // ============ SAVE ORDER ============
  static Future<void> saveOrder({
    required int tableNumber,
    required List<MenuItem> items,
    required Map<MenuItem, int> quantities,
    required bool isVeg,
    double discountAmount = 0.0,
    double discountPercentage = 0.0,
    String? discountReason,
  }) async {
    try {
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';

      double subtotal = 0.0;
      for (var item in items) {
        subtotal += item.price * (quantities[item] ?? 1);
      }

      // Calculate final discount
      double finalDiscount = 0.0;
      if (discountPercentage > 0) {
        finalDiscount = (subtotal * discountPercentage / 100).clamp(0, subtotal);
      } else if (discountAmount > 0) {
        finalDiscount = discountAmount.clamp(0, subtotal);
      }

      double totalAmount = (subtotal - finalDiscount).clamp(0, double.infinity);

      await _firestore.collection('orders').doc(orderId).set({
        'tableNumber': tableNumber,
        'orderType': tableNumber > 0 ? 'table' : 'counter',
        'isVeg': isVeg,
        'subtotal': subtotal,
        'discountAmount': finalDiscount,
        'discountPercentage': discountPercentage,
        'discountReason': discountReason,
        'totalAmount': totalAmount,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'items': items.map((item) {
          return {
            'name': item.name,
            'price': item.price,
            'isVeg': item.isVeg,
            'imagePlaceholder': item.imagePlaceholder,
            'quantity': quantities[item] ?? 1,
          };
        }).toList(),
      });

      print("✅ Order saved: $orderId");
      print("   Subtotal: ₹${subtotal.toInt()}");
      print("   Discount: ₹${finalDiscount.toInt()}");
      print("   Total: ₹${totalAmount.toInt()}");
      if (discountReason != null) {
        print("   Reason: $discountReason");
      }
    } catch (e) {
      print("❌ Error saving order: $e");
    }
  }

  // ============ ADD INVENTORY ITEM ============
  static Future<void> addInventoryItem(InventoryItem item) async {
    try {
      print("📝 Adding inventory item: ${item.name}");
      await _firestore.collection('inventory').doc(item.id).set({
        'name': item.name,
        'category': item.category,
        'stock': item.stock,
        'lowStockThreshold': item.lowStockThreshold,
        'purchasePrice': item.purchasePrice,
        'sellingPrice': item.sellingPrice,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print("✅ Item added: ${item.name}");
    } catch (e) {
      print("❌ Error adding inventory item: $e");
      rethrow;
    }
  }

  // ============ UPDATE INVENTORY ITEM ============
  static Future<void> updateInventoryItem(InventoryItem item) async {
    try {
      print("📝 Updating inventory item: ${item.name}");
      await _firestore.collection('inventory').doc(item.id).update({
        'name': item.name,
        'category': item.category,
        'stock': item.stock,
        'lowStockThreshold': item.lowStockThreshold,
        'purchasePrice': item.purchasePrice,
        'sellingPrice': item.sellingPrice,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print("✅ Item updated: ${item.name}");
    } catch (e) {
      print("❌ Error updating inventory item: $e");
      rethrow;
    }
  }

  // ============ DELETE INVENTORY ITEM ============
  static Future<void> deleteInventoryItem(String itemId) async {
    try {
      print("🗑️  Deleting inventory item: $itemId");
      await _firestore.collection('inventory').doc(itemId).delete();
      print("✅ Item deleted: $itemId");
    } catch (e) {
      print("❌ Error deleting inventory item: $e");
      rethrow;
    }
  }

  // ============ MENU CATEGORY MANAGEMENT ============

  static Stream<QuerySnapshot> getMenuCategoriesStream() {
    return _firestore.collection('menu_categories').snapshots();
  }

  static Future<void> createMenuCategory(String categoryName) async {
    try {
      print("📝 Creating menu category: $categoryName");
      await _firestore.collection('menu_categories').add({
        'name': categoryName,
        'icon': 'restaurant',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("✅ Category created: $categoryName");
    } catch (e) {
      print("❌ Error creating category: $e");
      rethrow;
    }
  }

  static Future<void> deleteMenuCategory(String categoryId) async {
    try {
      print("🗑️  Deleting menu category: $categoryId");
      await _firestore.collection('menu_categories').doc(categoryId).delete();
      print("✅ Category deleted: $categoryId");
    } catch (e) {
      print("❌ Error deleting category: $e");
      rethrow;
    }
  }

  // ============ HELPER METHODS ============

  static IconData _getIconFromString(String iconName) {
    final iconMap = {
      'local_pizza': Icons.local_pizza,
      'lunch_dining': Icons.lunch_dining,
      'fastfood': Icons.fastfood,
      'local_drink': Icons.local_drink,
      'favorite_border': Icons.favorite_border,
    };
    return iconMap[iconName] ?? Icons.restaurant;
  }

// ============ BULK INSERT MENU DATA ============
  static Future<void> bulkInsertMenuData(Map<String, dynamic> menuData) async {
    try {
      print("🚀 Starting bulk insertion of menu data...");

      final List<dynamic> categories = menuData['categories'] ?? [];

      for (var category in categories) {
        try {
          print("\n📁 Processing category: ${category['name']}");

          // Add category to Firestore
          final categoryRef = await _firestore.collection('menu_categories').add({
            'name': category['name'] as String,
            'icon': category['icon'] as String? ?? 'restaurant',
            'createdAt': FieldValue.serverTimestamp(),
          });

          print("✅ Category created: ${categoryRef.id}");

          // Add items to category
          final List<dynamic> items = category['items'] ?? [];

          for (var item in items) {
            try {
              final itemData = {
                'name': item['name'] as String,
                'price': (item['price'] as num).toDouble(),
                'isVeg': item['isVeg'] as bool? ?? false,
                'imagePlaceholder': item['imagePlaceholder'] as String? ?? '',
                'haveVarients': item['haveVarients'] as bool? ?? false,
                'varients': item['varients'] as List? ?? [],
                'inventoryType': item['inventoryType'] as String? ?? 'recipe',
                'createdAt': FieldValue.serverTimestamp(),
              };

              // Add inventory-specific fields
              if (item['inventoryType'] == 'quantity') {
                itemData['inventoryQuantity'] =
                    (item['inventoryQuantity'] as num?)?.toDouble() ?? 0.0;
                itemData['inventoryUnit'] =
                    item['inventoryUnit'] as String? ?? 'kg';
              } else if (item['inventoryType'] == 'recipe') {
                itemData['recipe'] = item['recipe'] as List? ?? [];
              }

              await categoryRef.collection('items').add(itemData);
              print("   ✅ Item added: ${item['name']}");
            } catch (e) {
              print("   ❌ Error adding item: $e");
            }
          }
        } catch (e) {
          print("❌ Error processing category: $e");
        }
      }

      print("\n🎉 Bulk insertion completed successfully!");
    } catch (e) {
      print("❌ Error during bulk insertion: $e");
      rethrow;
    }
  }

}