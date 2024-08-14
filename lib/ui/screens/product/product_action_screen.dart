
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/product/product_bloc.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/helper/pop_up_helper.dart';
import 'package:sanber_flutter_final_project/ui/widgets/ink_well_button_widget.dart';
import 'package:sanber_flutter_final_project/ui/widgets/text_form_field_widget.dart';

class ProductActionScreen extends StatefulWidget {
  final Product? product;
  const ProductActionScreen({super.key, this.product});

  @override
  State<ProductActionScreen> createState() => _ProductActionScreenState();
}

class _ProductActionScreenState extends State<ProductActionScreen> {
  late ProductBloc _productBloc;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _satuanController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  late TextEditingController _imgSrcController;
  late TextEditingController _descriptionController;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _imgSrcController.text = pickedImage.path;
    }
  }

  Future<void> _onAdd() async {
    _productBloc.add(
      AddProduct(
        Product(
            nama: _namaController.text,
            satuan: _satuanController.text,
            harga: PropertyHelper.fromIDR(_hargaController.text),
            stok: int.tryParse(_stokController.text) ?? 0,
            imgSrc: _imgSrcController.text,
            description: _descriptionController.text),
      ),
    );
    PopUpHelper.snackbar(context, message: 'Berhasil ditambahkan');
    context.pop();
  }

  Future<void> _onEdit() async {
    PopUpHelper.dialog(
      context,
      dialogState: DialogState.edit,
      identifier: widget.product!.nama,
      onContinue: () {
        _productBloc.add(
          EditProduct(
            Product(
                id: widget.product!.id,
                nama: _namaController.text,
                satuan: _satuanController.text,
                harga: PropertyHelper.fromIDR(_hargaController.text),
                stok: int.tryParse(_stokController.text) ?? 0,
                imgSrc: _imgSrcController.text,
                description: _descriptionController.text),
          ),
        );

        PopUpHelper.snackbar(context, message: 'Berhasil diupdate');
        context.pop();
      },
    );
  }

  Future<void> _onDelete() async {
    PopUpHelper.dialog(
      context,
      dialogState: DialogState.delete,
      identifier: widget.product!.nama,
      onContinue: () {
        _productBloc.add(DeleteProduct(widget.product!));
        PopUpHelper.snackbar(context, message: 'Berhasil dihapus');
        context.pop();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _productBloc = context.read<ProductBloc>();

    _namaController = TextEditingController();
    _satuanController = TextEditingController();
    _hargaController = TextEditingController();
    _stokController = TextEditingController();
    _imgSrcController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.product != null) {
      _namaController.text = widget.product!.nama;
      _satuanController.text = widget.product!.satuan;
      _hargaController.text = PropertyHelper.toIDR(widget.product!.harga.toString());
      _stokController.text = widget.product!.stok.toString();
      _imgSrcController.text = widget.product!.imgSrc;
      _descriptionController.text = widget.product!.description;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _satuanController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _imgSrcController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Tambah product' : 'Edit product'),
        actions: widget.product != null
            ? [
                IconButton.filledTonal(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            themeHelper.colorScheme.errorContainer)),
                    color: themeHelper.colorScheme.error,
                    onPressed: () {
                      _onDelete();
                    },
                    icon: const Icon(Icons.delete)),
                const SizedBox(
                  width: 16,
                )
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormFieldWidget(
                  textEditingController: _namaController,
                  label: 'Nama',
                  placeholder: 'Paracetamol 500MG',
                  prefixIcon: Icons.inventory_2,
                ),
                TextFormFieldWidget(
                  textEditingController: _satuanController,
                  label: 'Satuan',
                  placeholder: 'PCS',
                  prefixIcon: Icons.bar_chart_sharp,
                ),
                TextFormFieldWidget(
                  placeholder: PropertyHelper.toIDR('10000'),
                  textEditingController: _hargaController,
                  label: 'Harga',
                  prefixIcon: Icons.price_change,
                  onChanged: (p0) {
                    final formattedValue = PropertyHelper.toIDR(p0);
                    _hargaController.value = _hargaController.value.copyWith(
                      text: formattedValue,
                      selection: TextSelection.collapsed(
                          offset: formattedValue.length),
                    );
                  },
                ),
                TextFormFieldWidget(
                  textEditingController: _stokController,
                  label: 'Stok',
                  placeholder: '1',
                  prefixIcon: Icons.dataset,
                ),
                TextFormFieldWidget(
                  textEditingController: _imgSrcController,
                  label: 'Gambar',
                  placeholder: 'path',
                  prefixIcon: Icons.image,
                  suffix: FilledButton.tonalIcon(
                    onPressed: () => _pickImage(),
                    icon: const Icon(
                      Icons.upload,
                      size: 20,
                    ),
                    label: Text(
                      'Pilih',
                      style: themeHelper.textTheme.labelSmall,
                    ),
                  ),
                ),
                TextFormFieldWidget(
                  textEditingController: _descriptionController,
                  label: 'Deskripsi',
                  placeholder: 'Digunakan untuk menghilangkan nyeri',
                  prefixIcon: Icons.note,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 32,
                ),
                InkWellButtonWidget.primary(
                  label: widget.product != null ? 'Simpan' : 'Tambah',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.product == null) {
                        _onAdd();
                      } else {
                        _onEdit();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
