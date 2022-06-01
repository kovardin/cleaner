import 'package:cleaner/constants.dart';
import 'package:cleaner/screens/tabs/home/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Statistics extends ConsumerWidget {
  const Statistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 65,
        ),
        Container(
          height: 212,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                0.0,
                1,
              ],
              colors: [
                PrimaryColor,
                SecondaryColor,
              ],
            ),
          ),
          child: Column(
            children: [
              ref.watch(homeStateProvider).memory > 0 ? Stat(title: 'Memory usage', value: ref.watch(homeStateProvider).memory) : Container(),
              ref.watch(homeStateProvider).storage > 0 ? Stat(title: 'Storage used', value: ref.watch(homeStateProvider).storage) : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

class Stat extends StatefulWidget {
  const Stat({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final double value;

  @override
  _StatState createState() => _StatState();
}

class _StatState extends State<Stat> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<double> valueTween;

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    this._controller.forward();

    this.valueTween = Tween<double>(
      begin: 0,
      end: this.widget.value / 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: theme.textTheme.bodyText2?.copyWith(color: Color(0xFFD4EFFF))),
          Text("${widget.value.toStringAsFixed(2)}%", style: theme.textTheme.headline1?.copyWith(color: Colors.white)),
          AnimatedBuilder(
            child: Container(),
            builder: (context, child) {
              return LinearProgressIndicator(
                color: Colors.white,
                value: this.valueTween.evaluate(this._controller),
              );
            },
            animation: this._controller,
          ),
        ],
      ),
      padding: EdgeInsets.all(18),
    );
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }
}
