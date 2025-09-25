import 'package:flutter/material.dart';
import 'package:cackecal/models/ingredient.dart'; // 👈 هذا هو المهم
import 'package:cackecal/repository/ingredient_repository.dart';
import 'package:cackecal/database/database_helper.dart';
class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late IngredientRepository _repository;
  List<Ingredient> ingredients = [];

  @override
  void initState() {
    super.initState();
    _repository = IngredientRepository(DatabaseHelper());
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    await _repository.initializeDefaultData(); // تأكد من وجود بيانات افتراضية
    final data = await _repository.getIngredients();
    setState(() {
      ingredients = data;
    });
  }

  void _addIngredient() {
    String name = "";
    double price = 0;
    double quantity = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text("إضافة مكون جديد",
            style: TextStyle(color: Colors.pink[800], fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "اسم المكون",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.pink[700]),
              ),
              onChanged: (val) => name = val,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "سعر الوحدة",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.pink[700]),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) => price = double.tryParse(val) ?? 0,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "كمية الوحدة",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.pink[700]),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) => quantity = double.tryParse(val) ?? 0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () async {
              if (name.isNotEmpty && price > 0 && quantity > 0) {
                await _repository.insertIngredient(
                    Ingredient(name: name, unitPrice: price, unitQuantity: quantity));
                _loadIngredients();
              }
              Navigator.pop(context);
            },
            child: Text("إضافة", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _updateIngredient(Ingredient ingredient) async {
    await _repository.updateIngredient(ingredient);
    _loadIngredients();
  }

  void _deleteIngredient(int id) async {
    await _repository.deleteIngredient(id);
    _loadIngredients();
  }

  @override
  Widget build(BuildContext context) {
    double totalInvoice = ingredients.fold(0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text("فاتورة مكونات الكعك 🎂"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.pink[800], size: 30),
            onPressed: _addIngredient,
          )
        ],
      ),
      body: ingredients.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cake, size: 80, color: Colors.pink[200]),
            SizedBox(height: 20),
            Text("لا توجد مكونات بعد!", style: TextStyle(fontSize: 18, color: Colors.brown[600])),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addIngredient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("أضف أول مكون", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 12,
              headingRowHeight: 45,
              dataRowMinHeight: 45,
              dataRowMaxHeight: 55,
              headingRowColor: MaterialStateProperty.resolveWith<Color?>((_) => Colors.pink[100]),
              columns: [
                DataColumn(label: Text("المكون", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]))),
                DataColumn(label: Text("سعر/وحدة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]))),
                DataColumn(label: Text("كمية/وحدة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]))),
                DataColumn(label: Text("مستعمل", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]))),
                DataColumn(label: Text("السعر الكلي", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]))),
                DataColumn(label: Text("إجراءات", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]))),
              ],
              rows: ingredients.asMap().entries.map((entry) {
                final index = entry.key;
                final ingredient = entry.value;

                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>((_) => index % 2 == 0 ? Colors.pink[50] : Colors.white),
                  cells: [
                    DataCell(Text(ingredient.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: ingredient.unitPrice.toString()),
                          style: TextStyle(fontSize: 13),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8), border: OutlineInputBorder()),
                          onSubmitted: (val) {
                            ingredient.unitPrice = double.tryParse(val) ?? ingredient.unitPrice;
                            _updateIngredient(ingredient);
                          },
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: ingredient.unitQuantity.toString()),
                          style: TextStyle(fontSize: 13),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8), border: OutlineInputBorder()),
                          onSubmitted: (val) {
                            ingredient.unitQuantity = double.tryParse(val) ?? ingredient.unitQuantity;
                            _updateIngredient(ingredient);
                          },
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: ingredient.usedQuantity.toString()),
                          style: TextStyle(fontSize: 13),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8), border: OutlineInputBorder()),
                          onSubmitted: (val) {
                            ingredient.usedQuantity = double.tryParse(val) ?? 0;
                            _updateIngredient(ingredient);
                          },
                        ),
                      ),
                    ),
                    DataCell(Text(
                      "${ingredient.totalPrice.toStringAsFixed(2)} دج",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[700]),
                    )),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.red[400], size: 24),
                        onPressed: () => _deleteIngredient(ingredient.id!),
                        tooltip: "حذف المكون",
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink[50],
          border: Border(top: BorderSide(color: Colors.pink[200]!, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("إجمالي الفاتورة:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[800])),
            Text(
              "${totalInvoice.toStringAsFixed(2)} دج",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
            ),
          ],
        ),
      ),
    );
  }
}