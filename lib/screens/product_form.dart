import 'package:flutter/material.dart';
import 'package:app/widgets/left_drawer.dart';
import 'package:app/widgets/product_card.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:app/screens/menu.dart';

class ProductFormPage extends StatefulWidget {
    const ProductFormPage({super.key});

    @override
    State<ProductFormPage> createState() => ProductFormPageState();
}

class ProductFormPageState extends State<ProductFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _name = "";
    String _price = "";
    String _description = "";
    String? _category; // default to null to avoid mismatch with items
    String _thumbnail = "";
    bool _isFeatured = false; // default

  final List<String> _categories = [
    'shoes',
    'apparel',
    'equipment',
    'collector',
    'misc',
  ];
    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
        return Scaffold(
  appBar: AppBar(
    title: const Center(
      child: Text(
        'Create Product Form',
      ),
    ),
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
  ),
  drawer: const LeftDrawer(),
  body: Form(
     key: _formKey,
     child: SingleChildScrollView(
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children:[
    // === Title ===
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Nama Produk",
          labelText: "Nama Produk",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onChanged: (String? value) {
          setState(() {
            _name = value!;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "Judul tidak boleh kosong!";
          }
          return null;
        },
      ),
    ),
      // === Price ===
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Harga Produk ",
        labelText: "Harga Produk (RP)",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          _price = value!;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Harga tidak boleh kosong!";
        }
        return null;
      },
    ),
  ),

   // === Description ===
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Deskripsi",
        labelText: "Deskripsi",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          _description = value!;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Deskripsi tidak boleh kosong!";
        }
        return null;
      },
    ),
  ),

  // === Category ===
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButtonFormField<String?>(
      decoration: InputDecoration(
        labelText: "Kategori",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      value: _category,
      hint: const Text('Pilih Kategori'),
      items: _categories
          .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat[0].toUpperCase() + cat.substring(1)),
              ))
          .toList(),
      onChanged: (String? newValue) {
        setState(() {
          _category = newValue;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    ),
  ),

  // === Thumbnail URL ===
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      decoration: InputDecoration(
        hintText: "URL Thumbnail",
        labelText: "URL Thumbnail",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          _thumbnail = value!;
        });
      },
      validator: (value) {
            if (value == null || value.isEmpty) {
            return 'Please enter a URL';
            }
            try {
            final uri = Uri.parse(value);
            if (!uri.isAbsolute) {
                return 'Please enter a valid URL';
            }
            } catch (e) {
            return 'Invalid URL format';
            }
            return null; // Input is valid
        },
    ),
  ),

  // === Is Featured ===
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: SwitchListTile(
      title: const Text("Tandai sebagai Produk Unggulan"),
      value: _isFeatured,
      onChanged: (bool value) {
        setState(() {
          _isFeatured = value;
        });
      },
    ),
  ),

  // === Tombol Simpan ===
    Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.indigo),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // TODO: Replace the URL with your app's URL
              // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
              // If you using chrome,  use URL http://localhost:8000
              
              final response = await request.postJson(
                "http://localhost:8000/create-flutter/",
                jsonEncode({
                  "name": _name,
                  "price": _price,
                  "thumbnail": _thumbnail,
                  "description": _description,
                  "category": _category,
                  "is_featured": _isFeatured,
                }),
              );
              if (context.mounted) {
                if (response['status'] == 'success') {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content: Text("Product successfully added!"),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content: Text("Something went wrong, please try again."),
                  ));
                }
              }
            }
          },
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
    ),
    ),
  ],
     )),
),
);
    }
}