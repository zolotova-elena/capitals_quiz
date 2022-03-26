import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Wave extends StatelessWidget {
  final Color color;
  final Duration duration;

  const Wave({
    Key? key,
    required this.color,
    this.duration = const Duration(seconds: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [Colors.transparent, color],
        ],
        durations: [duration.inMilliseconds],
        heightPercentages: [0.0],
        blur: const MaskFilter.blur(BlurStyle.solid, 10),
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      waveAmplitude: 0,
      size: const Size(
        double.infinity,
        double.infinity,
      ),
    );
  }
}
