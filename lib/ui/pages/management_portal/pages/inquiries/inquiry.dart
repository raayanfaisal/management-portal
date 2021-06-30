import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/currency_picker_dropdown.dart';

import '../../../../../utility/collection.dart';
import '../../../../../app/app.dart';
import '../../../../common/my_account_actions_button.dart';
import '../../../../common/confirmation_dialog.dart';
import 'vendor_calculation.dart';
import 'vendor_form_dialog.dart';
import 'new_vendor_item_dialog.dart';

class InquiryPage extends StatefulWidget {
  final InquiryModel inquiry;

  const InquiryPage({Key? key, required this.inquiry}) : super(key: key);

  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Focus(
          focusNode: _focusNode,
          child: Column(children: [
            _buildHeader(),
            Flexible(child: _buildVendorList(context)),
          ]),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kTextTabBarHeight + 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(children: [
          const BackButton(),
          Text(
            widget.inquiry.inquiryId,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .apply(fontWeightDelta: 2),
          ),
          const SizedBox(width: 16),
          Text(
            widget.inquiry.inquiryStatus.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const SizedBox(
            width: 400,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
              ),
            ),
          ),
          const SizedBox(width: 32),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sort),
            label: const Text('Sort'),
          ),
          const SizedBox(width: 32),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter'),
          ),
          const SizedBox(width: 32),
          TextButton.icon(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return VendorFormDialog(
                    title: 'New vendor',
                    doneLabel: 'Add',
                    onDone:
                        (id, company, department, name, email, contact) async {
                      await context.read<InquiryRepository>().addVendor(
                            widget.inquiry.inquiryId,
                            id: id,
                            company: company,
                            department: department,
                            name: name,
                            email: email,
                            contact: contact,
                          );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('New vendor'),
          ),
          const SizedBox(width: 32),
          const MyAccountActionsButton(),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Customer ID:'),
              Text('Customer:'),
              Text('Name:'),
              Text('Address:'),
              Text('Email:'),
              Text('Contact:'),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(widget.inquiry.customerId),
              SelectableText(widget.inquiry.customer),
              SelectableText(widget.inquiry.name),
              SelectableText(widget.inquiry.address),
              SelectableText(widget.inquiry.contactEmail),
              SelectableText(widget.inquiry.contactMobile),
            ],
          ),
          const SizedBox(width: 32),
          const Text('Description:'),
          const SizedBox(width: 8),
          Text(widget.inquiry.description),
        ],
      ),
    );
  }

  Widget _buildVendorList(BuildContext context) {
    return StreamBuilder<List<VendorModel>>(
      stream:
          context.read<InquiryRepository>().vendors(widget.inquiry.inquiryId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final vendors = snapshot.data!;

        return Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: vendors.length,
            itemBuilder: (_, index) {
              return _VendorTile(
                inquiryId: widget.inquiry.inquiryId,
                vendor: vendors.elementAt(index),
              );
            },
          ),
        );
      },
    );
  }
}

class _VendorItem {
  bool isEditingDetails = false;
  VendorItemModel _item;
  late final modelOrPartTextController =
      TextEditingController(text: _item.modelOrPart);
  late final descriptionTextController =
      TextEditingController(text: _item.description);
  late final quantityTextController =
      TextEditingController(text: _item.quantity.toString());
  late final priceTextController =
      TextEditingController(text: _item.price.toStringAsFixed(2));
  late final dutyPercentageTextController =
      TextEditingController(text: _item.dutyPercentage.toStringAsFixed(2));
  late final markUpPercentageTextController =
      TextEditingController(text: _item.markUpPercentage.toStringAsFixed(2));

  _VendorItem(this._item);

  String get id => _item.id;

  VendorItemModel get model {
    return _item.copyWith(
      modelOrPart: modelOrPartTextController.text,
      description: descriptionTextController.text,
      quantity: int.tryParse(quantityTextController.text) ?? 1,
      price: num.tryParse(priceTextController.text) ?? 0,
      dutyPercentage: num.tryParse(dutyPercentageTextController.text) ?? 0,
      markUpPercentage: num.tryParse(markUpPercentageTextController.text) ?? 0,
    );
  }

  void update({
    required num freightTotal,
    Currency? foreignCurrency,
    Currency? localCurrency,
  }) {
    _item = model.copyWith(
      freightTotal: freightTotal,
      foreignCurrency: foreignCurrency,
      localCurrency: localCurrency,
    );
  }
}

class _VendorTile extends StatefulWidget {
  final String inquiryId;
  final VendorModel vendor;

  const _VendorTile({Key? key, required this.inquiryId, required this.vendor})
      : super(key: key);

  @override
  __VendorTileState createState() => __VendorTileState();
}

class __VendorTileState extends State<_VendorTile>
    with AutomaticKeepAliveClientMixin {
  late final _freightChargesTextController = TextEditingController(
    text: widget.vendor.freightCharges.toStringAsFixed(2),
  );
  late final _adjustmentTextController =
      TextEditingController(text: widget.vendor.adjustment.toStringAsFixed(2));
  late final _hclTextController =
      TextEditingController(text: widget.vendor.hcl.toStringAsFixed(2));

  VendorModel? _vendor;
  late final _items = <String, _VendorItem>{};
  late final _removedItems = <String>{};

  VendorModel get _vendorModel => _vendor ?? widget.vendor;

  VendorModel get _vendorChanged {
    return _vendorModel.copyWith(
      items: _itemsChanged.values.map((e) => e.model).toList(),
    );
  }

  Map<String, _VendorItem> get _itemsChanged {
    final items = widget.vendor.items
        .map((e) => _items.containsKey(e.id) ? _items[e.id]! : _VendorItem(e));

    return {
      for (final item in items)
        if (!_removedItems.contains(item.id))
          item.id: item
            ..update(
              freightTotal: _itemFreightTotal(item.model),
              foreignCurrency: _vendorModel.foreignCurrency,
              localCurrency: _vendorModel.localCurrency,
            ),
    };
  }

  void _revertChanges() {
    setState(() {
      _vendor = null;
      _items.clear();
      _removedItems.clear();
      _freightChargesTextController.text =
          widget.vendor.freightCharges.toStringAsFixed(2);
      _adjustmentTextController.text =
          widget.vendor.adjustment.toStringAsFixed(2);
      _hclTextController.text = widget.vendor.hcl.toStringAsFixed(2);
    });
  }

  double _itemFreightPercentage(VendorItemModel item) {
    return item.totalPrice / _vendorModel.totalPrice * 100;
  }

  double _itemFreightTotal(VendorItemModel item) {
    return _vendorModel.freightReference * _itemFreightPercentage(item) / 100;
  }

  // TODO: user role
  // TODO: zoho sync vendor customer
  // TODO: go back on menu item press
  // TODO: disable fields when locked

  @override
  final wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
      color: Theme.of(context).canvasColor,
      child: ExpansionTile(
        maintainState: true,
        initiallyExpanded: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        iconColor: Theme.of(context).primaryColor,
        collapsedIconColor: Theme.of(context).primaryColor,
        title: _buildTitle(context),
        children: [
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _VendorTable(
              freightChargesTextController: _freightChargesTextController,
              adjustmentTextController: _adjustmentTextController,
              hclTextController: _hclTextController,
              vendor: _vendorChanged,
              items: _itemsChanged.values.toList(),
              onVendorChanged: (vendor) => setState(() => _vendor = vendor),
              onItemChanged: (item) => setState(() => _items[item.id] = item),
              onItemRemoved: (item) {
                setState(() => _removedItems.add(item.id));
              },
              calculateItemFreightPercentage: _itemFreightPercentage,
            ),
          ),
          if (_vendor != null || _items.isNotEmpty || _removedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: _buildUnsavedChangesArea(context),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(children: [
      ...[
        _buildTitleItem(context, 'ID', widget.vendor.id!),
        _buildTitleItem(context, 'COMPANY', widget.vendor.company),
        _buildTitleItem(context, 'NAME', widget.vendor.name),
        _buildTitleItem(context, 'EMAIL', widget.vendor.email),
        _buildTitleItem(context, 'CONTACT', widget.vendor.contact),
      ].intersperse(const SizedBox(width: 32)),
      const Spacer(),
      IconButton(
        tooltip: _vendorChanged.isLocked ? 'Unlock' : 'Lock',
        color: Theme.of(context).buttonColor,
        icon: Icon(
          _vendorChanged.isLocked ? Icons.lock : Icons.lock_open,
          color: _vendorChanged.isLocked ? Colors.red : Colors.green,
        ),
        onPressed: () {
          setState(() {
            _vendor =
                _vendorChanged.copyWith(isLocked: !_vendorChanged.isLocked);
          });
        },
      ),
      DropdownButton<VendorStatus>(
        dropdownColor: Theme.of(context).cardColor,
        style: Theme.of(context).primaryTextTheme.button,
        items: [
          for (final item in VendorStatus.values)
            DropdownMenuItem(
              value: item,
              child: Text(item.name, style: _buildVendorStatusStyle(item)),
            ),
        ],
        underline: const SizedBox.shrink(),
        value: _vendorChanged.status,
        onChanged: (value) {
          setState(() => _vendor = _vendorChanged.copyWith(status: value!));
        },
      ),
      IconButton(
        tooltip: 'Add item',
        color: Theme.of(context).buttonColor,
        icon: const Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) {
              return NewVendorItemDialog(
                inquiryId: widget.inquiryId,
                vendor: widget.vendor,
              );
            },
          );
        },
      ),
      IconButton(
        tooltip: 'Edit vendor',
        color: Theme.of(context).buttonColor,
        icon: const Icon(Icons.edit),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) {
              return VendorFormDialog(
                title: 'Edit vendor',
                doneLabel: 'Save',
                vendorId: widget.vendor.id,
                initialCompany: widget.vendor.company,
                initialDepartment: widget.vendor.department,
                initialName: widget.vendor.name,
                initialEmail: widget.vendor.email,
                initialContact: widget.vendor.contact,
                onDone: (_, company, department, name, email, contact) async {
                  await context.read<InquiryRepository>().updateVendor(
                        widget.inquiryId,
                        widget.vendor.copyWith(
                          company: company,
                          department: department,
                          name: name,
                          email: email,
                          contact: contact,
                        ),
                      );
                },
              );
            },
          );
        },
      ),
      IconButton(
        tooltip: 'Remove vendor',
        color: Theme.of(context).errorColor,
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) {
              return ConfirmationDialog(
                title: 'Are you sure you want to remove vendor '
                    '${widget.vendor.id}?',
                onConfirm: () async {
                  await context
                      .read<InquiryRepository>()
                      .removeVendor(widget.inquiryId, widget.vendor.id!);
                },
              );
            },
          );
        },
      ),
    ]);
  }

  Widget _buildTitleItem(BuildContext context, String label, String value) {
    return SelectableText.rich(
      TextSpan(children: [
        TextSpan(
          text: '$label:  ',
          style: Theme.of(context).primaryTextTheme.caption,
        ),
        TextSpan(
          text: value,
          style: Theme.of(context).primaryTextTheme.bodyText1,
        ),
      ]),
    );
  }

  TextStyle _buildVendorStatusStyle(VendorStatus status) {
    switch (status) {
      case VendorStatus.approved:
        return const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        );
      case VendorStatus.rejected:
        return const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
      default:
        return const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        );
    }
  }

  Widget _buildUnsavedChangesArea(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'You have unsaved changes!',
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
        TextButton(
          onPressed: _revertChanges,
          child: const Text('Revert changes'),
        ),
        ElevatedButton(
          onPressed: () async {
            await context
                .read<InquiryRepository>()
                .updateVendor(widget.inquiryId, _vendorChanged);

            _revertChanges();
          },
          child: const Text('Save changes'),
        ),
      ].intersperse(const SizedBox(width: 8)),
    );
  }
}

class _VendorTable extends StatefulWidget {
  final TextEditingController freightChargesTextController;
  final TextEditingController adjustmentTextController;
  final TextEditingController hclTextController;
  final VendorModel vendor;
  final List<_VendorItem> items;
  final void Function(VendorModel vendor) onVendorChanged;
  final void Function(_VendorItem item) onItemChanged;
  final void Function(_VendorItem item) onItemRemoved;
  final double Function(VendorItemModel item) calculateItemFreightPercentage;

  const _VendorTable({
    Key? key,
    required this.freightChargesTextController,
    required this.adjustmentTextController,
    required this.hclTextController,
    required this.vendor,
    required this.items,
    required this.onVendorChanged,
    required this.onItemChanged,
    required this.calculateItemFreightPercentage,
    required this.onItemRemoved,
  }) : super(key: key);

  @override
  __VendorTableState createState() => __VendorTableState();
}

class __VendorTableState extends State<_VendorTable>
    with AutomaticKeepAliveClientMixin {
  @override
  final wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {0: FixedColumnWidth(360)},
              border: TableBorder(
                verticalInside: BorderSide(color: Theme.of(context).cardColor),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                  children: <Widget>[
                    Text(
                      'ITEM DETAILS',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'QTY',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'UNIT EXW\nF/C',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'TTL EXW\nF/C',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'UNIT EXW',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'TTL EXW',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'FRT. %',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'FRT.\nAMNT',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'FRT. TTL',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'DUTY %',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'DUTY\nAMNT',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'DUTY\nTTL',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'UNIT\nCOST',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'TTL\nCOST',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'MARK\nUP %',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'UNIT\nPROFIT',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'TTL\nPROFIT',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'UNIT SELLING\nPRICE',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      'TTL SELLING\nPRICE',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(fontWeightDelta: 2),
                    ),
                    const SizedBox.shrink(),
                  ].map((cell) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: cell,
                    );
                  }).toList(),
                ),
                for (final item in widget.items)
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                    children: <Widget>[
                      ...[
                        _VendorItemDetails(
                          isEditing: item.isEditingDetails,
                          id: item.model.id,
                          modelOrPartTextController:
                              item.modelOrPartTextController,
                          descriptionTextController:
                              item.descriptionTextController,
                          onEditingChanged: (value) {
                            widget
                                .onItemChanged(item..isEditingDetails = value);
                          },
                          onDetailsChanged: () => widget.onItemChanged(item),
                        ),
                        Row(children: [
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: item.quantityTextController,
                              onChanged: (_) => widget.onItemChanged(item),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]+'),
                                )
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                              decoration: const InputDecoration(
                                isDense: true,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        TextField(
                          controller: item.priceTextController,
                          onChanged: (_) {
                            widget.onItemChanged(item);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                          ],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            isDense: true,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                          ),
                        ),
                        Text(
                          item.model.totalPrice.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.localPrice.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.totalLocalPrice.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          widget
                              .calculateItemFreightPercentage(item.model)
                              .toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.freightAmount.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.freightTotal.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Row(children: [
                          SizedBox(
                            width: 55,
                            child: TextField(
                              controller: item.dutyPercentageTextController,
                              onChanged: (value) {
                                widget.onItemChanged(item);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                              decoration: const InputDecoration(
                                isDense: true,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                suffixText: '%',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Text(
                          item.model.dutyAmount.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.dutyTotal.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.unitCost.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.totalCost.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Row(children: [
                          SizedBox(
                            width: 55,
                            child: TextField(
                              controller: item.markUpPercentageTextController,
                              onChanged: (value) {
                                widget.onItemChanged(item);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                              decoration: const InputDecoration(
                                isDense: true,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                suffixText: '%',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Text(
                          item.model.unitProfit.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.totalProfitLine.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.unitSellingPrice.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                        Text(
                          item.model.totalSellingPrice.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
                        ),
                      ].map((cell) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: cell,
                        );
                      }),
                      Material(
                        type: MaterialType.circle,
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: Tooltip(
                          message: 'Remove item',
                          child: InkWell(
                            onTap: () => widget.onItemRemoved(item),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                TableRow(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'TOTAL ITEMS:',
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .apply(fontSizeDelta: -1)
                              .apply(fontWeightDelta: 2),
                        ),
                        const SizedBox(height: 95),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vendor.totalItems.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2)
                              .apply(fontWeightDelta: 1),
                        ),
                        const SizedBox(height: 95),
                      ],
                    ),
                    Column(children: [
                      SizedBox(
                        height: 14,
                        child: Text(
                          'TTL EXW F/C:',
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .apply(fontSizeDelta: -1)
                              .apply(fontWeightDelta: 2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildForeignCurrencyInput(context),
                      const SizedBox(height: 40),
                    ]),
                    Column(children: [
                      SizedBox(
                        height: 14,
                        child: Text(
                          widget.vendor.totalPrice.toStringAsFixed(2),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeDelta: -2)
                              .apply(fontWeightDelta: 1),
                        ),
                      ),
                      const SizedBox(height: 95),
                    ]),
                    Column(children: [
                      SizedBox(
                        height: 14,
                        child: Text(
                          'TTL EXW:',
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .apply(fontSizeDelta: -1)
                              .apply(fontWeightDelta: 2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildLocalCurrencyInput(context),
                      const SizedBox(height: 40),
                    ]),
                    _buildFreightDropdownButtons(),
                    _buildFreightDropdownButtons2(),
                    _buildFreightSummary(),
                    _buildFreightSummary2(),
                    const SizedBox.shrink(),
                    Column(children: [
                      _buildTotalDuty(),
                      const SizedBox(height: 95),
                    ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTotalDuty2(),
                        const SizedBox(height: 95),
                      ],
                    ),
                    Column(children: [
                      _buildTotalCost(),
                      const SizedBox(height: 95),
                    ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTotalCost2(),
                        const SizedBox(height: 95),
                      ],
                    ),
                    const SizedBox.shrink(),
                    Column(children: [
                      _buildTotalProfit(),
                      const SizedBox(height: 95),
                    ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTotalProfit2(),
                        const SizedBox(height: 95),
                      ],
                    ),
                    _buildSellingPriceSummary(),
                    _buildSellingPriceSummary2(),
                    const SizedBox.shrink(),
                  ].map((cell) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: cell,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildForeignCurrencyInput(BuildContext context) {
    return _CurrencyInput(
      currency: widget.vendor.foreignCurrency?.code,
      value: widget.vendor.foreignCurrency?.value,
      onCurrencyChanged: (country) {
        widget.onVendorChanged(
          widget.vendor.copyWith(
            foreignCurrency: widget.vendor.foreignCurrency
                ?.copyWith(code: country!.currencyCode!),
          ),
        );
      },
      onValueChanged: (value) {
        widget.onVendorChanged(
          widget.vendor.copyWith(
            foreignCurrency:
                widget.vendor.foreignCurrency?.copyWith(value: value),
          ),
        );
      },
    );
  }

  Widget _buildLocalCurrencyInput(BuildContext context) {
    return _CurrencyInput(
      isEnabled: false,
      currency: widget.vendor.localCurrency?.code,
      value: widget.vendor.localCurrency?.value,
      countryFilter: (country) {
        return country.isoCode == 'US' || country.isoCode == 'MV';
      },
      onCurrencyChanged: (country) {
        widget.onVendorChanged(
          widget.vendor.copyWith(
            localCurrency: widget.vendor.localCurrency
                ?.copyWith(code: country!.currencyCode!),
          ),
        );
      },
      onValueChanged: (value) {
        widget.onVendorChanged(
          widget.vendor.copyWith(
            localCurrency: widget.vendor.localCurrency?.copyWith(value: value),
          ),
        );
      },
    );
  }

  Widget _buildFreightDropdownButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: 14,
          child: Text(
            widget.vendor.totalLocalPrice.toStringAsFixed(2),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(fontSizeDelta: -2)
                .apply(fontWeightDelta: 1),
          ),
        ),
        const SizedBox(height: 42),
        ...[
          SizedBox(
            height: 24,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'INCO TERMS:',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .apply(fontSizeDelta: -1)
                    .apply(fontWeightDelta: 2),
              ),
            ),
          ),
          SizedBox(
            height: 24,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'CARRIER:',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .apply(fontSizeDelta: -1)
                    .apply(fontWeightDelta: 2),
              ),
            ),
          ),
        ].intersperse(const SizedBox(height: 4)),
      ],
    );
  }

  Widget _buildFreightDropdownButtons2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 54),
        Container(
          width: 56,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: DropdownButton<VendorFreightType>(
            isDense: true,
            isExpanded: true,
            dropdownColor: Theme.of(context).cardColor,
            items: [
              for (final type in VendorFreightType.values)
                DropdownMenuItem(
                  value: type,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(type.name),
                  ),
                ),
            ],
            style: Theme.of(context)
                .textTheme
                .caption!
                .apply(fontSizeDelta: -1, fontWeightDelta: 2),
            underline: const SizedBox.shrink(),
            value: widget.vendor.freightType,
            onChanged: (value) {
              widget
                  .onVendorChanged(widget.vendor.copyWith(freightType: value!));
            },
          ),
        ),
        Container(
          width: 56,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: DropdownButton<VendorFreightMethod>(
            isDense: true,
            isExpanded: true,
            dropdownColor: Theme.of(context).cardColor,
            items: [
              for (final method in VendorFreightMethod.values)
                DropdownMenuItem(
                  value: method,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(method.name),
                  ),
                ),
            ],
            style: Theme.of(context)
                .textTheme
                .caption!
                .apply(fontSizeDelta: -1, fontWeightDelta: 2),
            underline: const SizedBox.shrink(),
            value: widget.vendor.freightMethod,
            onChanged: (value) {
              widget.onVendorChanged(
                widget.vendor.copyWith(freightMethod: value!),
              );
            },
          ),
        ),
      ].intersperse(const SizedBox(height: 4)),
    );
  }

  Widget _buildFreightSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'TTL FRT.:',
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .apply(fontSizeDelta: -1)
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              'FRT. REF:',
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .apply(fontSizeDelta: -1, fontWeightDelta: 2),
            ),
          ]
              .map((e) {
                return SizedBox(
                  height: 14,
                  child: Align(alignment: Alignment.centerRight, child: e),
                );
              })
              .intersperse(const SizedBox(height: 4))
              .toList(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'FRT. CHG:',
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .apply(fontSizeDelta: -1, fontWeightDelta: 2),
            ),
            Text(
              'ADJ:',
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .apply(fontSizeDelta: -1)
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              'HCL:',
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .apply(fontSizeDelta: -1, fontWeightDelta: 2),
            ),
          ]
              .map((e) {
                return SizedBox(
                  height: 22,
                  child: Align(alignment: Alignment.centerRight, child: e),
                );
              })
              .intersperse(const SizedBox(height: 4))
              .toList(),
        ),
      ].intersperse(const SizedBox(height: 4)),
    );
  }

  Widget _buildFreightSummary2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          widget.vendor.totalFreight.toStringAsFixed(2),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2)
              .apply(fontWeightDelta: 1),
        ),
        Text(
          widget.vendor.freightReference.toStringAsFixed(2),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2)
              .apply(fontWeightDelta: 1),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: widget.freightChargesTextController,
            onChanged: (value) {
              widget.onVendorChanged(
                widget.vendor
                    .copyWith(freightCharges: num.tryParse(value) ?? 0),
              );
            },
            textAlign: TextAlign.right,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(fontSizeDelta: -2, fontWeightDelta: 1),
            decoration: const InputDecoration(
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: widget.adjustmentTextController,
            onChanged: (value) {
              widget.onVendorChanged(
                widget.vendor.copyWith(adjustment: num.tryParse(value) ?? 0),
              );
            },
            textAlign: TextAlign.right,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(fontSizeDelta: -2)
                .apply(fontWeightDelta: 1),
            decoration: const InputDecoration(
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: widget.hclTextController,
            onChanged: (value) {
              widget.onVendorChanged(
                widget.vendor.copyWith(hcl: num.tryParse(value) ?? 0),
              );
            },
            textAlign: TextAlign.right,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(fontSizeDelta: -2, fontWeightDelta: 1),
            decoration: const InputDecoration(
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
            ),
          ),
        ),
      ].intersperse(const SizedBox(height: 4)),
    );
  }

  Widget _buildTotalDuty() {
    return Text(
      'TTL DUTY:',
      textAlign: TextAlign.end,
      style: Theme.of(context)
          .textTheme
          .caption!
          .apply(fontSizeDelta: -1)
          .apply(fontWeightDelta: 2),
    );
  }

  Widget _buildTotalDuty2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.vendor.totalDuty.toStringAsFixed(2),
          textAlign: TextAlign.right,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2)
              .apply(fontWeightDelta: 1),
        ),
      ],
    );
  }

  Widget _buildTotalCost() {
    return Text(
      'TTL COST:',
      textAlign: TextAlign.end,
      style: Theme.of(context)
          .textTheme
          .caption!
          .apply(fontSizeDelta: -1)
          .apply(fontWeightDelta: 2),
    );
  }

  Widget _buildTotalCost2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.vendor.totalCost.toStringAsFixed(2),
          textAlign: TextAlign.right,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2)
              .apply(fontWeightDelta: 1),
        ),
      ],
    );
  }

  Widget _buildTotalProfit() {
    return Text(
      'TTL PROFIT:',
      textAlign: TextAlign.end,
      style: Theme.of(context)
          .textTheme
          .caption!
          .apply(fontSizeDelta: -1)
          .apply(fontWeightDelta: 2),
    );
  }

  Widget _buildTotalProfit2() {
    return Text(
      widget.vendor.totalProfitLine.toStringAsFixed(2),
      textAlign: TextAlign.right,
      style: Theme.of(context)
          .textTheme
          .bodyText1!
          .apply(fontSizeDelta: -2)
          .apply(fontWeightDelta: 1),
    );
  }

  Widget _buildSellingPriceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'SUB TTL:',
          textAlign: TextAlign.end,
          style: Theme.of(context)
              .textTheme
              .caption!
              .apply(fontSizeDelta: -1)
              .apply(fontWeightDelta: 2),
        ),
        Text(
          'GST AMNT:',
          textAlign: TextAlign.end,
          style: Theme.of(context)
              .textTheme
              .caption!
              .apply(fontSizeDelta: -1)
              .apply(fontWeightDelta: 2),
        ),
        Text(
          'GRAND TTL:',
          textAlign: TextAlign.end,
          style: Theme.of(context)
              .textTheme
              .caption!
              .apply(fontSizeDelta: -1)
              .apply(fontWeightDelta: 2),
        ),
        const SizedBox(height: 70),
      ].intersperse(const SizedBox(width: 4)),
    );
  }

  Widget _buildSellingPriceSummary2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          widget.vendor.totalSellingPrice.toStringAsFixed(2),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2)
              .apply(fontWeightDelta: 1),
        ),
        Text(
          widget.vendor.gstAmount.toStringAsFixed(2),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2)
              .apply(fontWeightDelta: 1),
        ),
        Text(
          widget.vendor.grandTotal.toStringAsFixed(2),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2)
              .apply(fontWeightDelta: 1),
        ),
        const SizedBox(height: 70),
      ].intersperse(const SizedBox(width: 4)),
    );
  }
}

class _VendorItemDetails extends StatefulWidget {
  final bool isEditing;
  final String id;
  final TextEditingController modelOrPartTextController;
  final TextEditingController descriptionTextController;
  final ValueChanged<bool> onEditingChanged;
  final VoidCallback onDetailsChanged;

  const _VendorItemDetails({
    Key? key,
    required this.isEditing,
    required this.id,
    required this.modelOrPartTextController,
    required this.descriptionTextController,
    required this.onEditingChanged,
    required this.onDetailsChanged,
  }) : super(key: key);

  @override
  __VendorItemDetailsState createState() => __VendorItemDetailsState();
}

class __VendorItemDetailsState extends State<_VendorItemDetails> {
  void _startEditing() => widget.onEditingChanged(true);

  void _cancelEditing() => widget.onEditingChanged(false);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widget.isEditing
            ? _buildItems(context).intersperse(const SizedBox(height: 4))
            : _buildItems(context),
      ),
      Positioned(
        right: 0,
        child: Material(
          type: MaterialType.circle,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: Tooltip(
            message: widget.isEditing ? 'Cancel' : 'Edit details',
            child: InkWell(
              onTap: widget.isEditing ? _cancelEditing : _startEditing,
              child:
                  Icon(widget.isEditing ? Icons.cancel : Icons.edit, size: 16),
            ),
          ),
        ),
      ),
    ]);
  }

  List<Widget> _buildItems(BuildContext context) {
    return [
      Tooltip(
        message: widget.id,
        child: Text(
          widget.id,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
        ),
      ),
      if (widget.isEditing)
        TextField(
          controller: widget.modelOrPartTextController,
          onChanged: (_) => widget.onDetailsChanged(),
          maxLines: null,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
          decoration: const InputDecoration(
            isDense: true,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
          ),
        )
      else
        Tooltip(
          message: widget.modelOrPartTextController.text,
          child: Text(
            widget.modelOrPartTextController.text,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(fontSizeDelta: -2, fontWeightDelta: 1),
          ),
        ),
      if (widget.isEditing)
        TextField(
          controller: widget.descriptionTextController,
          onChanged: (_) => widget.onDetailsChanged(),
          maxLines: null,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .apply(fontSizeDelta: -2, fontWeightDelta: 1),
          decoration: const InputDecoration(
            isDense: true,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
          ),
        )
      else
        Tooltip(
          message: widget.descriptionTextController.text,
          child: Text(
            widget.descriptionTextController.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.apply(
                  fontSizeDelta: -2,
                  fontWeightDelta: 1,
                ),
          ),
        ),
    ];
  }
}

class _CurrencyInput extends StatefulWidget {
  final bool isEnabled;
  final String? currency;
  final num? value;
  final void Function(Country? country) onCurrencyChanged;
  final void Function(num value) onValueChanged;
  final bool Function(Country country)? countryFilter;

  const _CurrencyInput({
    Key? key,
    this.isEnabled = true,
    this.currency = 'USD',
    this.value = 1,
    required this.onCurrencyChanged,
    required this.onValueChanged,
    this.countryFilter,
  }) : super(key: key);

  @override
  __CurrencyInputState createState() => __CurrencyInputState();
}

class __CurrencyInputState extends State<_CurrencyInput> {
  late final _valueTextController =
      TextEditingController(text: widget.value.toString());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: CurrencyPickerDropdown(
            initialValue: widget.currency,
            itemFilter: widget.countryFilter,
            onValuePicked: widget.onCurrencyChanged,
            itemBuilder: (country) {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  country.currencyCode!,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .apply(fontSizeDelta: -1, fontWeightDelta: 2),
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: 55,
          child: TextField(
            enabled: widget.isEnabled,
            controller: _valueTextController,
            onChanged: (value) {
              widget.onValueChanged(num.tryParse(value) ?? 1);
            },
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(fontSizeDelta: -2, fontWeightDelta: 1),
            decoration: const InputDecoration(
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
            ),
          ),
        ),
      ].intersperse(const SizedBox(height: 4)),
    );
  }
}
