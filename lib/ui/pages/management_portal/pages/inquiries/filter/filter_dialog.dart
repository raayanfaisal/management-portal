import 'package:flutter/material.dart';

import '../../../../../../app/app.dart';
import '../../../../../../utility/collection.dart';
import 'filter.dart';

export 'filter.dart';

class InquiryFilters {
  final List<Filter> included;
  final List<Filter> excluded;

  InquiryFilters._([this.included = const [], this.excluded = const []]);

  bool accepts(InquiryModel inquiry) {
    return _isNotExcluded(inquiry) && _isIncluded(inquiry);
  }

  bool _isIncluded(InquiryModel inquiry) {
    if (included.isNotEmpty) {
      return included.any((filter) => filter.accepts(inquiry));
    }
    return true;
  }

  bool _isNotExcluded(InquiryModel inquiry) {
    if (excluded.isNotEmpty) {
      return excluded.every((filter) => !filter.accepts(inquiry));
    }
    return true;
  }
}

class FilterDialog extends StatefulWidget {
  final List<CategoryModel> categories;
  final InquiryFilters? filters;

  FilterDialog({Key? key, required this.categories, required this.filters})
      : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late final List<Filter> _includedFilters = [...?widget.filters?.included];
  late final List<Filter> _excludedFilters = [...?widget.filters?.excluded];

  bool get _hasFilters {
    return _includedFilters.isNotEmpty || _excludedFilters.isNotEmpty;
  }

  void _toggleFilter(Filter filter) {
    setState(() {
      if (_includedFilters.contains(filter)) {
        _includedFilters.remove(filter);
        _excludedFilters.add(filter);
      } else if (_excludedFilters.contains(filter)) {
        _excludedFilters.remove(filter);
      } else {
        _includedFilters.add(filter);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _includedFilters.clear();
      _excludedFilters.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      title: Row(children: [
        const Text('Filter'),
        const Spacer(),
        ElevatedButton(
          onPressed: _hasFilters ? _clearFilters : null,
          child: const Text('Clear filters'),
        ),
      ]),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: _buildContent(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_includedFilters.isNotEmpty || _excludedFilters.isNotEmpty) {
              Navigator.of(context)
                  .pop(InquiryFilters._(_includedFilters, _excludedFilters));
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text('Done', style: Theme.of(context).primaryTextTheme.button),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSection(
          context,
          'Customer status',
          _buildFilters(context, CustomerStatusFilter.values),
        ),
        _buildSection(
          context,
          'Inquiry status',
          _buildFilters(context, InquiryStatusFilter.values),
        ),
        if (widget.categories.isNotEmpty)
          _buildSection(
            context,
            'Categories',
            _buildFilters(
              context,
              widget.categories.map((label) => CategoryFilter(label)).toList(),
            ),
          ),
      ].intersperse(_buildDivider(context)),
    );
  }

  Widget _buildSection(BuildContext context, String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style:
              Theme.of(context).textTheme.subtitle1?.apply(fontWeightDelta: 2),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildFilters(BuildContext context, List<Filter> filters) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.start,
      children: filters.map((filter) {
        return _FilterChip(
          name: filter.name,
          color: _buildFilterColor(context, filter),
          onPressed: () => _toggleFilter(filter),
        );
      }).toList(),
    );
  }

  Color _buildFilterColor(BuildContext context, Filter filter) {
    if (_includedFilters.contains(filter)) {
      return Theme.of(context).primaryColor;
    } else if (_excludedFilters.contains(filter)) {
      return Theme.of(context).errorColor;
    }
    return Colors.blueGrey;
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(1),
        child: Material(color: Theme.of(context).dividerColor),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback? onPressed;

  const _FilterChip({
    Key? key,
    required this.name,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelStyle = color.computeLuminance() > 0.5
        ? Theme.of(context).textTheme.bodyText2
        : Theme.of(context).primaryTextTheme.bodyText2;

    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(name, style: labelStyle),
        ),
      ),
    );
  }
}
