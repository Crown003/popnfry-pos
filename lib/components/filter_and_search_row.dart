import 'package:flutter/material.dart';
import 'dart:async';

class FilterAndSearchRow extends StatefulWidget {
  final bool showVegOnly;
  final ValueChanged<bool> onVegToggled;
  final ValueChanged<String> onSearchChanged;
  final String searchQuery;

  const FilterAndSearchRow({
    super.key,
    required this.showVegOnly,
    required this.onVegToggled,
    required this.onSearchChanged,
    required this.searchQuery,
  });

  @override
  State<FilterAndSearchRow> createState() => _FilterAndSearchRowState();
}

class _FilterAndSearchRowState extends State<FilterAndSearchRow> {
  late final TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);

    _searchController.addListener(() {
      // 3. This logic handles the "Wait"
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        widget.onSearchChanged(_searchController.text);
      });
    });
  }

  @override
  void didUpdateWidget(covariant FilterAndSearchRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the search query from the parent has actually changed
    if (widget.searchQuery != oldWidget.searchQuery) {
      if (widget.searchQuery != _searchController.text) {
        _searchController.value = TextEditingValue(
          text: widget.searchQuery,
          selection: TextSelection.collapsed(offset: widget.searchQuery.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel(); // 4. Always cancel timers when closing the page
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchChanged('');
    // FocusScope.of(context).requestFocus(FocusNode()..requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Veg / Non-Veg Toggle
          GestureDetector(
            onTap: () => widget.onVegToggled(!widget.showVegOnly),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.showVegOnly ? Colors.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "VEG",
                      style: TextStyle(
                        color: widget.showVegOnly ? Colors.white : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: !widget.showVegOnly ? Colors.red : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "NON-VEG",
                      style: TextStyle(
                        color: !widget.showVegOnly ? Colors.white : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Search TextField with reactive clear button
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, child) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search items...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}