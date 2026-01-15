import 'package:flutter/material.dart';

class SliverAppBarTitle extends StatefulWidget {
  final Widget child;
  const SliverAppBarTitle({
    super.key,
    required this.child,
  });
  @override
  State<SliverAppBarTitle> createState() => _SliverAppBarTitleState();
}
class _SliverAppBarTitleState extends State<SliverAppBarTitle> {
  ScrollPosition? _position;
  bool _visible = false;
  
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  
  void _addListener() {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      _position = scrollable.position;
      _position?.addListener(_positionListener);
      _positionListener();
    }
  }
  
  void _removeListener() {
    if (_position != null) {
      _position!.removeListener(_positionListener);
      _position = null;
    }
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
    context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible = settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Visibility(visible: _visible, child: widget.child);
}