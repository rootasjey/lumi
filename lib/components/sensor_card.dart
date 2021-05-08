import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/state/colors.dart';

class SensorCard extends StatefulWidget {
  final double elevation;

  final Sensor sensor;

  final VoidCallback onTap;
  final VoidCallback onToggle;

  const SensorCard({
    Key key,
    @required this.sensor,
    this.onTap,
    this.onToggle,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  _SensorCardState createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.sensor.id,
      child: SizedBox(
        width: 240.0,
        height: 240.0,
        child: Card(
          elevation: widget.elevation,
          child: InkWell(
            onTap: widget.onTap,
            child: Stack(
              children: [
                texts(),
                toggleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget texts() {
    final sensor = widget.sensor;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Text(
              sensor.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Tooltip(
            message:
                "${sensor.config.battery}% of battery remaining for this sensor",
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: Icon(
                    sensor.config.battery < 5
                        ? Icons.battery_alert
                        : Icons.battery_full,
                    color: sensor.config.battery < 5
                        ? Colors.red.shade300
                        : stateColors.foreground,
                  ),
                ),
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '${sensor.config.battery}%',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget toggleButton() {
    final sensor = widget.sensor;

    return Positioned(
      top: 20.0,
      left: 20.0,
      child: IconButton(
        tooltip: 'Turn ${sensor.config.on ? 'off' : 'on'}',
        onPressed: widget.onToggle,
        icon: Icon(
          Icons.sensor_window_outlined,
          size: 30.0,
          color: sensor.config.on
              ? stateColors.primary
              : stateColors.foreground.withOpacity(0.6),
        ),
      ),
    );
  }
}
