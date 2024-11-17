import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:scaitica/utils/constant.dart';

class GaugeIndicator extends StatefulWidget {
  const GaugeIndicator({super.key});

  @override
  State<GaugeIndicator> createState() => _GaugeIndicatorState();
}

double bmi = 0.0;

class _GaugeIndicatorState extends State<GaugeIndicator> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedRadialGauge(

        /// The animation duration.
        duration: const Duration(seconds: 10),
        curve: Curves.elasticOut,
        /// Define the radius.
        /// If you omit this value, the parent size will be used, if possible.
        radius: 100,

        /// Gauge value.
        value: bmi,

        /// Optionally, you can configure your gauge, providing additional
        /// styles and transformers.
        axis: GaugeAxis(

            /// Provide the [min] and [max] value for the [value] argument.
            min: 0,
            max: 40,

            /// Render the gauge as a 180-degree arc.
            degrees: 180,

            /// Set the background color and axis thickness.
            style: const GaugeAxisStyle(
              segmentSpacing: 10,
              thickness: 18,
              background: Colors.transparent,
            ),

            /// Define the pointer that will indicate the progress (optional).
            pointer: const GaugePointer.needle(
              width: 15,
              height: 40,
              borderRadius: 16,
              color: Color.fromARGB(255, 0, 0, 0),
            ),

            /// Define the progress bar (optional).
            progressBar: const GaugeProgressBar.rounded(
              color: color16,
              placement: GaugeProgressPlacement.over,
            ),

            /// Define axis segments (optional).
            segments: [
              GaugeSegment(
                from: 0,
                to: bmi,
                color: const Color(0xFFD9DEEB),
                cornerRadius: const Radius.circular(10)
              ),
              GaugeSegment(
                from: bmi,
                to: 40.0,
                color: const Color(0xFFD9DEEB),
                cornerRadius: const Radius.circular(10),
              ),
              // GaugeSegment(
              //   from: 26.0,
              //   to: 40,
              //   color: Color(0xFFD9DEEB),
              //   cornerRadius: Radius.circular(10),
              // ),
            ]),

        /// You can also, define the child builder.
        /// You will build a value label in the following way, but you can use the widget of your choice.
        ///
        /// For non-value related widgets, take a look at the [child] parameter.
        /// ```
        builder: (context, child, value) => RadialGaugeLabel(
              value: bmi,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),

              /// ),
              /// ```
            ));
  }
}
