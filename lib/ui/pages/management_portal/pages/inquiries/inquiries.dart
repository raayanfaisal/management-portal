import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:full_text_search/full_text_search.dart';

import '../../../../../utility/collection.dart';
import '../../../../../app/app.dart';
import '../../../../helpers/hex_color.dart';
import '../../../../common/my_account_actions_button.dart';
import '../../../../common/confirmation_dialog.dart';
import '../../../../common/category.dart';
import 'inquiry.dart';
import 'inquiry_form_dialog.dart';
import 'filter/filter_dialog.dart';

class InquiriesPage extends StatefulWidget {
  const InquiriesPage({Key? key}) : super(key: key);

  @override
  _InquiriesPageState createState() => _InquiriesPageState();
}

class _InquiriesPageState extends State<InquiriesPage> {
  // TODO: search field
  final _searchTextController = TextEditingController();
  var _sortAscending = false;
  var _sortBy = InquiriesSortBy.date;
  InquiryFilters? _filters;

  Stream<Iterable<InquiryModel>> _inquiries(BuildContext context) {
    return context
        .read<InquiryRepository>()
        .inquiries(sortBy: _sortBy, ascending: _sortAscending)
        .map((inquiries) {
      return inquiries.where((inquiry) => _filters?.accepts(inquiry) ?? true);
    });
  }

  Stream<Iterable<InquiryModel>> _searchResults(BuildContext context) {
    return _inquiries(context).asyncMap((inquiries) async {
      if (_searchTextController.text.isEmpty) {
        return inquiries;
      }
      return FullTextSearch<InquiryModel>(
        term: _searchTextController.text,
        items: inquiries,
        tokenize: (inquiry) {
          return [
            inquiry.inquiryId,
            inquiry.customerId,
            inquiry.customer,
            inquiry.name,
            inquiry.description,
            inquiry.assignee,
          ];
        },
      ).findResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      home: StreamProvider<List<CategoryModel>>(
        initialData: const [],
        create: (context) => context.read<CategoryRepository>().categories(),
        child: Builder(builder: _buildHome),
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(children: [
        _buildHeader(context),
        const Divider(height: 0),
        Flexible(
          child: StreamBuilder<Iterable<InquiryModel>>(
            stream: _searchResults(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LinearProgressIndicator();
              }
              final inquiries = snapshot.data!;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: inquiries.isEmpty
                    ? _buildNoResultsMessage(context)
                    : _buildInquiryList(inquiries),
              );
            },
          ),
        ),
        const Divider(height: 0),
      ]),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).backgroundColor),
          ),
        ),
        child: Row(children: [
          Text(
            'Inquiry',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .apply(fontWeightDelta: 2),
          ),
          const Spacer(),
          SizedBox(
            width: 400,
            child: TextField(
              controller: _searchTextController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
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
            onPressed: () async {
              final selectedFilters = await showDialog<InquiryFilters?>(
                context: context,
                builder: (_) {
                  return FilterDialog(
                    categories: context.read(),
                    filters: _filters,
                  );
                },
              );
              setState(() => _filters = selectedFilters);
            },
            icon: _filters != null
                ? Icon(Icons.filter_list, color: Colors.amberAccent[700])
                : const Icon(Icons.filter_list),
            label: _filters != null
                ? Text(
                    'Filter',
                    style: TextStyle(color: Colors.amberAccent[700]),
                  )
                : const Text('Filter'),
          ),
          const SizedBox(width: 32),
          TextButton.icon(
            onPressed: () => _showAddInquiryDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('New inquiry'),
          ),
          const SizedBox(width: 32),
          const MyAccountActionsButton(),
        ]),
      ),
    );
  }

  Widget _buildNoResultsMessage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        _searchTextController.text.isNotEmpty || _filters != null
            ? 'Nothing found matching your search query/filters'
            : "There's nothing here",
        style: textTheme.headline6!.copyWith(color: textTheme.caption!.color),
      ),
    );
  }

  Widget _buildInquiryList(Iterable<InquiryModel> inquiries) {
    return Scrollbar(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: inquiries.length,
        itemBuilder: (context, index) {
          return _InquiryTile(inquiry: inquiries.elementAt(index));
        },
        separatorBuilder: (_, __) => const Divider(height: 0),
      ),
    );
  }

  Future<void> _showAddInquiryDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return InquiryFormDialog(
          title: 'New inquiry',
          doneLabel: 'Add',
          onDone: (
            id,
            customerId,
            customer,
            name,
            address,
            contactEmail,
            contactMobile,
            description,
            assignee,
            date,
            categories,
          ) async {
            await context.read<InquiryRepository>().addInquiry(
                  inquiryId: id,
                  customerId: customerId,
                  customer: customer,
                  name: name,
                  address: address,
                  contactEmail: contactEmail,
                  contactMobile: contactMobile,
                  description: description,
                  assignee: assignee,
                  date: date,
                  categories: categories,
                );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    Widget buildLabel(String label) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.caption!.apply(fontWeightDelta: 2),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Checkbox(
              value: false,
              onChanged: (_) {},
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_sortBy != InquiriesSortBy.inquiryId) {
                    _sortBy = InquiriesSortBy.inquiryId;
                    _sortAscending = true;
                  } else {
                    _sortAscending = !_sortAscending;
                  }
                });
              },
              child: Row(
                children: [
                  buildLabel('INQ ID'),
                  if (_sortBy == InquiriesSortBy.inquiryId)
                    Icon(
                      _sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 16,
                    )
                ].intersperse(const SizedBox(width: 4)),
              ),
            ),
          ),
          Expanded(child: buildLabel('CUS ID')),
          Expanded(flex: 3, child: buildLabel('CUSTOMER')),
          Expanded(flex: 2, child: buildLabel('NAME')),
          Expanded(flex: 3, child: buildLabel('DESCRIPTION')),
          Expanded(flex: 1, child: buildLabel('CATEGORIES')),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_sortBy != InquiriesSortBy.date) {
                    _sortBy = InquiriesSortBy.date;
                    _sortAscending = true;
                  } else {
                    _sortAscending = !_sortAscending;
                  }
                });
              },
              child: Row(
                children: [
                  buildLabel('DATE'),
                  if (_sortBy == InquiriesSortBy.date)
                    Icon(
                      _sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 16,
                    )
                ].intersperse(const SizedBox(width: 4)),
              ),
            ),
          ),
          Expanded(child: buildLabel('ASSIGNED TO')),
          Expanded(child: buildLabel('CUS STATUS')),
          Expanded(child: buildLabel('INQ STATUS')),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: buildLabel('ACTION'),
            ),
          ),
          const SizedBox(width: 42),
        ].intersperse(const SizedBox(width: 8)),
      ),
    );
  }
}

class _InquiryTile extends StatefulWidget {
  final InquiryModel inquiry;

  const _InquiryTile({Key? key, required this.inquiry}) : super(key: key);

  @override
  __InquiryTileState createState() => __InquiryTileState();
}

class __InquiryTileState extends State<_InquiryTile>
    with AutomaticKeepAliveClientMixin {
  static final _dateFormatter = DateFormat('y-M-d');

  @override
  final wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
      color: _buildColor()?.withOpacity(0.5) ?? Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return InquiryPage(inquiry: widget.inquiry);
            }),
          );
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Checkbox(value: false, onChanged: (_) {}),
            ),
            Expanded(child: _buildLabel(context, widget.inquiry.inquiryId)),
            Expanded(child: _buildLabel(context, widget.inquiry.customerId)),
            Expanded(
              flex: 3,
              child: _buildLabel(context, widget.inquiry.customer),
            ),
            Expanded(
              flex: 2,
              child: _buildLabel(context, widget.inquiry.name),
            ),
            Expanded(
              flex: 3,
              child: _buildLabel(context, widget.inquiry.description),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  for (final category in context.read<List<CategoryModel>>())
                    if (widget.inquiry.categories.contains(category.id))
                      Tooltip(
                        message: category.name,
                        child: Category(
                          name: category.name
                              .split(' ')
                              .map((e) => e[0].toUpperCase())
                              .join(),
                          color: HexColor.fromHexString(category.color),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                        ),
                      )
                ].intersperse(const SizedBox(width: 2)),
              ),
            ),
            Expanded(
              child: _buildLabel(
                  context, _dateFormatter.format(widget.inquiry.date)),
            ),
            Expanded(child: _buildLabel(context, widget.inquiry.assignee)),
            Expanded(
              child: DropdownButton<CustomerStatus>(
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  for (final item in CustomerStatus.values)
                    DropdownMenuItem(
                      value: item,
                      child: _buildLabel(context, item.name),
                    )
                ],
                underline: const SizedBox.shrink(),
                value: widget.inquiry.customerStatus,
                onChanged: (value) async {
                  await context.read<InquiryRepository>().changeCustomerStatus(
                      inquiry: widget.inquiry, status: value!);
                },
              ),
            ),
            Expanded(
              child: DropdownButton<InquiryStatus>(
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  for (final item in InquiryStatus.values)
                    DropdownMenuItem(
                      value: item,
                      child: _buildLabel(context, item.name),
                    )
                ],
                underline: const SizedBox.shrink(),
                value: widget.inquiry.inquiryStatus,
                onChanged: (value) async {
                  await context
                      .read<InquiryRepository>()
                      .changeInquiryStatus(widget.inquiry, value!);
                },
              ),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: widget.inquiry.statusHistory.isNotEmpty
                        ? widget.inquiry.statusHistory.first.title
                        : null,
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: widget.inquiry.statusHistory.isNotEmpty
                        ? () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return _StatusHistoryDialog(
                                  inquiry: widget.inquiry,
                                  history: widget.inquiry.statusHistory,
                                );
                              },
                            );
                          }
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            _AddStatusDialog(inquiry: widget.inquiry),
                      );
                    },
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              tooltip: 'More',
              itemBuilder: (_) {
                return const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ];
              },
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    await _showEditInquiryDialog(context);
                    break;
                  case 'delete':
                    await _showConfirmDeleteDialog(context);
                    break;
                  default:
                }
              },
            )
          ].intersperse(const SizedBox(width: 8)),
        ),
      ),
    );
  }

  Color? _buildColor() {
    switch (widget.inquiry.customerStatus) {
      case CustomerStatus.onHold:
        return Colors.amber[100];
      case CustomerStatus.rejected:
        return Colors.red[100];
      case CustomerStatus.approved:
        return Colors.green[100];
      case CustomerStatus.accepted:
        return Colors.blue[100];
      default:
    }
  }

  Text _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .subtitle2!
          .apply(fontSizeDelta: -2, fontWeightDelta: 1),
    );
  }

  Future<void> _showEditInquiryDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return InquiryFormDialog(
          title: 'Edit Inquiry',
          doneLabel: 'Save',
          idFieldIsEnabled: false,
          inquiryId: widget.inquiry.inquiryId,
          initialCustomerId: widget.inquiry.customerId,
          initialCustomer: widget.inquiry.customer,
          initialName: widget.inquiry.name,
          initialAddress: widget.inquiry.address,
          initialContactEmail: widget.inquiry.contactEmail,
          initialContactMobile: widget.inquiry.contactMobile,
          initialDescription: widget.inquiry.description,
          initialAssignee: widget.inquiry.assignee,
          initialDate: widget.inquiry.date,
          initialCategories: widget.inquiry.categories,
          onDone: (
            id,
            customerId,
            customer,
            name,
            address,
            email,
            contact,
            description,
            assignee,
            date,
            categories,
          ) async {
            await context.read<InquiryRepository>().addInquiry(
                  inquiryId: id,
                  customerId: customerId,
                  customer: customer,
                  name: name,
                  address: address,
                  contactEmail: email,
                  contactMobile: contact,
                  description: description,
                  assignee: assignee,
                  date: date,
                  categories: categories,
                );
          },
        );
      },
    );
  }

  Future<void> _showConfirmDeleteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return ConfirmationDialog(
          title: 'Are you sure you want to delete inquiry '
              '${widget.inquiry.inquiryId}?',
          onConfirm: () async {
            await context
                .read<InquiryRepository>()
                .deleteInquiry(widget.inquiry.inquiryId);
          },
        );
      },
    );
  }
}

class _StatusHistoryDialog extends StatelessWidget {
  static final _dateFormatter = DateFormat('y-M-d, h:mm');

  final InquiryModel inquiry;
  final List<ActionStatus> history;

  const _StatusHistoryDialog({
    Key? key,
    required this.inquiry,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Action history'),
      content: SizedBox(
        width: 400,
        child: Timeline.tileBuilder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(right: 12),
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Theme.of(context).primaryColor,
          ),
          builder: TimelineTileBuilder.connected(
            contentsAlign: ContentsAlign.basic,
            itemCount: history.length,
            contentsBuilder: (context, index) {
              final item = history.elementAt(index);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title),
                    Text(_dateFormatter.format(item.date)),
                  ],
                ),
              );
            },
            connectorBuilder: (context, _, __) => const SolidLineConnector(),
            indicatorBuilder: (context, index) {
              if (index != 0) {
                return const OutlinedDotIndicator();
              }
              return const DotIndicator();
            },
            indicatorPositionBuilder: (_, __) => 0.25,
          ),
        ),
      ),
    );
  }
}

class _AddStatusDialog extends StatefulWidget {
  final InquiryModel inquiry;

  const _AddStatusDialog({Key? key, required this.inquiry}) : super(key: key);

  @override
  __AddStatusDialogState createState() => __AddStatusDialogState();
}

class __AddStatusDialogState extends State<_AddStatusDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  DateTime _date = DateTime.now();

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty';
    }
    return null;
  }

  bool get _formIsValid {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    return formIsValid && _validateTitle(_titleTextController.text) == null;
  }

  Future<void> _addStatus(BuildContext context) async {
    await context.read<InquiryRepository>().addActionStatusUpdate(
          widget.inquiry,
          title: _titleTextController.text,
          date: _date,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add action'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () => setState(() {}),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleTextController,
                validator: _validateTitle,
                decoration: const InputDecoration(
                  filled: true,
                  isDense: true,
                  labelText: 'Title',
                ),
              ),
              Card(
                elevation: 0,
                clipBehavior: Clip.none,
                margin: EdgeInsets.zero,
                color: Colors.grey[200],
                child: SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      Expanded(
                        child: InputDatePickerFormField(
                          fieldLabelText: 'Date',
                          initialDate: _date,
                          firstDate: DateTime(2020, 01),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          onDateSubmitted: (value) {
                            setState(() => _date = value);
                          },
                        ),
                      ),
                      IconButton(
                        tooltip: 'Pick date',
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020, 01),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );

                          if (pickedDate != null) {
                            setState(() => _date = pickedDate);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ].intersperse(const SizedBox(height: 8)),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _formIsValid ? () => _addStatus(context) : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
