import 'package:flutter/material.dart';

class MarkdownToolbar extends StatelessWidget {
  final Function(String format) onFormat;

  const MarkdownToolbar({super.key, required this.onFormat});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _toolBtn(Icons.format_bold, 'bold', tooltip: 'Bold'),
          _toolBtn(Icons.format_italic, 'italic', tooltip: 'Italic'),
          _toolBtn(Icons.code, 'code', tooltip: 'Inline Code'),
          const VerticalDivider(width: 20, indent: 10, endIndent: 10),
          _toolBtn(Icons.format_list_bulleted, 'list', tooltip: 'List Item'),
          _toolBtn(Icons.format_quote, 'quote', tooltip: 'Quote'),
          const VerticalDivider(width: 20, indent: 10, endIndent: 10),
          _toolBtn(Icons.link, 'link', tooltip: 'Link'),
          _toolBtn(Icons.horizontal_rule, 'separator', tooltip: 'Divider'),
          const VerticalDivider(width: 20, indent: 10, endIndent: 10),
          _textBtn('H1', 'h1'),
          _textBtn('H2', 'h2'),
        ],
      ),
    );
  }

  Widget _toolBtn(IconData icon, String format, {String? tooltip}) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: () => onFormat(format),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(icon, size: 20, color: Colors.grey[800]),
        ),
      ),
    );
  }

  Widget _textBtn(String label, String format) {
    return InkWell(
      onTap: () => onFormat(format),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
