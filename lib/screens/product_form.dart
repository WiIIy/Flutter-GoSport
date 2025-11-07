import 'package:flutter/material.dart';
import 'package:app/widgets/left_drawer.dart';
import 'package:app/widgets/news_card.dart';
import 'package:flutter/services.dart';

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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Produk berhasil tersimpan'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                           Text('Judul: $_name'),
                            Text('Isi: $_price'),
                            Text('Kategori: $_category'),
                            Text('Thumbnail: $_thumbnail'),
                            Text(
                                'Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          _formKey.currentState!.reset();
                        },
                      ),
                    ],
                  );
                },
              );
           
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