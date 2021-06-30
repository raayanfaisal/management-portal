import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';

import '../../../../../utility/collection.dart';
import '../../../../../app/app.dart';
import '../../../../helpers/hex_color.dart';
import '../../../../common/my_account_actions_button.dart';
import '../../../../common/category.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  Future<void> _createNewCategory(
    BuildContext context,
    String name,
    Color color,
    String? description,
  ) async {
    await context.read<CategoryRepository>().createCategory(
          name: name,
          color: color.toHexString(),
          description: description,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      // body: _buildTable(context),
      body: _buildCategories(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).backgroundColor),
            ),
          ),
          child: Row(children: [
            Text(
              'Categories',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(fontWeightDelta: 2),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _showCreateCategoryDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('New category'),
            ),
            const SizedBox(width: 32),
            const MyAccountActionsButton(),
          ]),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return StreamBuilder<List<CategoryModel>>(
      stream: context.read<CategoryRepository>().categories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final categories = snapshot.data!;

        return Scrollbar(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories.elementAt(index);

              return _CategoryTile(category: category);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
          ),
        );
      },
    );
  }

  Future<void> _showCreateCategoryDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a new category'),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 600,
            child: CategoryEditor(
              onCancel: () => Navigator.pop(context),
              onSave: (name, color, description) async {
                await _createNewCategory(context, name, color, description);

                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final CategoryModel category;

  const _CategoryTile({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile>
    with SingleTickerProviderStateMixin {
  bool _isEditing = false;

  void _startEditing() => setState(() => _isEditing = true);

  void _stopEditing() => setState(() => _isEditing = false);

  Future<void> _save(
    BuildContext context,
    String name,
    Color color,
    String? description,
  ) async {
    await context.read<CategoryRepository>().updateCategory(
          widget.category.copyWith(
            name: name,
            color: color.toHexString(),
            description: description,
          ),
        );
    _stopEditing();
  }

  Future<void> _delete(BuildContext context) {
    return context.read<CategoryRepository>().removeCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        side: BorderSide(
          width: 2,
          color: Theme.of(context).backgroundColor,
        ),
      ),
      child: AnimatedSizeAndFade(
        vsync: this,
        fadeDuration: const Duration(milliseconds: 300),
        sizeDuration: const Duration(milliseconds: 300),
        child:
            _isEditing ? _buildCategoryEditor(context) : _buildContent(context),
      ),
    );
  }

  Widget _buildCategoryEditor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Text(
            'Edit category',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        CategoryEditor(
          name: widget.category.name,
          color: HexColor.fromHexString(widget.category.color),
          description: widget.category.description,
          onCancel: _stopEditing,
          onSave: (name, color, description) {
            return _save(context, name, color, description);
          },
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(children: [
      Row(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Category(
                name: widget.category.name,
                color: HexColor.fromHexString(widget.category.color),
              ),
              if (widget.category.description != null)
                Text(widget.category.description!),
            ].intersperse(const SizedBox(height: 8)),
          ),
        )
      ]),
      Positioned(
        top: 0,
        right: 0,
        child: Row(children: [
          IconButton(
            tooltip: 'Edit',
            onPressed: _startEditing,
            icon: const Icon(Icons.edit, size: 20),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () => _delete(context),
            icon: const Icon(Icons.delete, size: 20),
          ),
        ]),
      ),
    ]);
  }
}

class CategoryEditor extends StatefulWidget {
  final String? name;
  final Color color;
  final String? description;
  final VoidCallback onCancel;
  final FutureOr<void> Function(
    String name,
    Color color,
    String? description,
  ) onSave;

  const CategoryEditor({
    Key? key,
    this.name,
    this.color = Colors.black,
    this.description,
    required this.onCancel,
    required this.onSave,
  }) : super(key: key);

  @override
  _CategoryEditorState createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final _nameTextController = TextEditingController(text: widget.name);
  late final _descriptionController =
      TextEditingController(text: widget.description);
  late Color _selectedColor = widget.color;
  bool _isSaving = false;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  bool get _formIsValid {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    return formIsValid && _validateName(_nameTextController.text) == null;
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);

    await widget.onSave(
      _nameTextController.text,
      _selectedColor,
      _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
    );

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () => setState(() {}),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Column(
              children: <Widget>[
                TextFormField(
                  enabled: !_isSaving,
                  controller: _nameTextController,
                  validator: _validateName,
                  decoration: const InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  enabled: !_isSaving,
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    labelText: 'Description',
                  ),
                ),
                _buildColorPicker(context),
              ].intersperse(const SizedBox(height: 8)),
            ),
          ),
          _buildButtonBar(context),
        ],
      ),
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return AnimatedSizeAndFade(
      vsync: this,
      sizeDuration: const Duration(milliseconds: 300),
      fadeDuration: const Duration(milliseconds: 300),
      child: _isSaving
          ? const LinearProgressIndicator()
          : ButtonBar(
              children: <Widget>[
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _formIsValid ? _onSave : null,
                  child: const Text('Save'),
                ),
              ],
            ),
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox.fromSize(
          size: const Size.square(32),
          child: Card(color: _selectedColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(_selectedColor.toHexString()),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Choose a color',
          icon: const Icon(Icons.color_lens),
          onPressed: !_isSaving ? _showColorPicker : null,
        ),
      ],
    );
  }

  Future<void> _showColorPicker() async {
    final color = await showDialog<Color>(
      context: context,
      builder: (_) => _ColorPicker(initialColor: _selectedColor),
    );

    if (color != null) {
      setState(() => _selectedColor = color);
    }
  }
}

class _ColorPicker extends StatefulWidget {
  final Color initialColor;

  const _ColorPicker({Key? key, this.initialColor = Colors.black})
      : super(key: key);

  @override
  __ColorPickerState createState() => __ColorPickerState();
}

class __ColorPickerState extends State<_ColorPicker> {
  late Color _selectedColor = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
          pickerColor: _selectedColor,
          onColorChanged: (color) => setState(() => _selectedColor = color),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedColor),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
