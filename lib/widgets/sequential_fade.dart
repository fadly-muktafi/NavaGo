import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Fade berurutan untuk konten beda tinggi/struktur: fade-out konten lama
/// sampai habis, swap di titik tak-terlihat, lalu fade-in konten baru.
/// Berbeda dengan crossfade (AnimatedSwitcher) yang menumpuk lama+baru
/// dan menjepret tinggi di akhir.
///
/// - Perubahan child dideteksi via [child] key (mis. ValueKey(tab)) —
///   child WAJIB ber-key seperti pada AnimatedSwitcher yang digantikannya.
/// - Tinggi diratakan mulus via AnimatedSize (bukan jepretan).
/// - Ketukan cepat di tengah jalan: snap langsung ke konten terbaru.
/// - Reduce-motion dibaca sendiri via MediaQuery → swap instan.
/// - [onSwapped] dipanggil tepat saat konten baru muncul — titik yang
///   tepat untuk mereset scroll (bukan saat konten lama masih fade).
class SequentialFade extends StatefulWidget {
  final Widget child;
  final Duration outDuration;
  final Duration inDuration;
  final VoidCallback? onSwapped;

  const SequentialFade({
    super.key,
    required this.child,
    this.outDuration = const Duration(milliseconds: 150),
    this.inDuration = const Duration(milliseconds: 150),
    this.onSwapped,
  });

  @override
  State<SequentialFade> createState() => _SequentialFadeState();
}

class _SequentialFadeState extends State<SequentialFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeOut;
  late final Animation<double> _fadeIn;
  late Widget _visibleChild;
  bool _fadingOut = false;
  bool _settled = true;

  @override
  void initState() {
    super.initState();
    _visibleChild = widget.child;
    _controller = AnimationController(vsync: this);
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: kEaseOut),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: kEaseOut),
    );
    _controller.addStatusListener(_onStatus);
  }

  @override
  void didUpdateWidget(SequentialFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child.key != oldWidget.child.key) {
      _startSwap();
    }
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  void _startSwap() {
    if (_reduceMotion) {
      // Reduce-motion: swap instan, tanpa animasi apa pun.
      setState(() {
        _visibleChild = widget.child;
        _settled = true;
        _fadingOut = false;
      });
      widget.onSwapped?.call();
      return;
    }
    if (_controller.isAnimating) {
      // Sibuk: snap — konten terbaru langsung tampil penuh, selesai.
      _controller.stop();
      setState(() {
        _visibleChild = widget.child;
        _settled = true;
        _fadingOut = false;
      });
      widget.onSwapped?.call();
      return;
    }
    setState(() {
      _fadingOut = true;
      _settled = false;
    });
    _controller
      ..duration = widget.outDuration
      ..forward(from: 0.0);
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (_fadingOut) {
      // Out selesai tepat di tak-terlihat: swap, lalu fade-in.
      setState(() {
        _visibleChild = widget.child;
        _fadingOut = false;
      });
      widget.onSwapped?.call();
      _controller
        ..duration = widget.inDuration
        ..forward(from: 0.0);
    } else if (!_settled) {
      setState(() => _settled = true);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final Animation<double> opacity =
        _settled ? kAlwaysCompleteAnimation : (_fadingOut ? _fadeOut : _fadeIn);
    return AnimatedSize(
      duration: reduce ? Duration.zero : widget.inDuration,
      curve: kEaseOut,
      alignment: Alignment.topCenter,
      child: FadeTransition(opacity: opacity, child: _visibleChild),
    );
  }
}
