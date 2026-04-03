import 'dart:async';

import 'package:flutter/cupertino.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double scrollSpeed;
 
  MarqueeText({
    required this.text,
    required this.style,
    this.scrollSpeed = 50.0, // pixels per second
  });
 
  @override
  _MarqueeTextState createState() => _MarqueeTextState();
}
 
class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late Timer _timer;
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMarquee();
    });
  }
 
  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }
 
  void _startMarquee() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (Timer timer) {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final delta =
            widget.scrollSpeed * 0.016; // 0.016 is the frame time (16ms)
 
        if (currentScroll + delta >= maxScrollExtent) {
          _scrollController.jumpTo(0.0);
        } else {
          _scrollController.animateTo(currentScroll + delta,
              duration: const Duration(milliseconds: 16), curve: Curves.linear);
        }
      }
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildText(),
              _buildText(), // duplicate the text for seamless scrolling
            ],
          ),
        );
      },
    );
  }
 
  Widget _buildText() {
    return Text(
      widget.text,
      style: widget.style,
    );
  }
}