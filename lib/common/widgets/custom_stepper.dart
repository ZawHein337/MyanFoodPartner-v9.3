import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  final List<CustomStepperStep> steps;
  final int initialActiveIndex;
  final VoidCallback goToNextStep;
  final VoidCallback goToPreviousStep;
  const CustomStepper({
    super.key,
    required this.steps,
    this.initialActiveIndex = 0,
    required this.goToNextStep,
    required this.goToPreviousStep,
  });
  @override
  State<CustomStepper> createState() => _CustomStepperState();
}
class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.steps.asMap().entries.map((entry) {
              int index = entry.key;
              CustomStepperStep step = entry.value;
              return Row(
                children: [
                  // Step Circle
                  Container(
                    padding: const EdgeInsets.all(4),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= widget.initialActiveIndex
                          ? step.color ?? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    child: Icon(
                      step.icon,
                      color: index <= widget.initialActiveIndex
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                  if (index < widget.steps.length - 1)
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: index < widget.initialActiveIndex
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          widget.steps[widget.initialActiveIndex].content,
          const SizedBox(height: 20),
          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: widget.initialActiveIndex > 0
                    ? widget.goToPreviousStep
                    : null,
                child: const Text("Back"),
              ),
              ElevatedButton(
                onPressed: widget.initialActiveIndex <
                    widget.steps.length - 1
                    ? widget.goToNextStep
                    : null,
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomStepperStep {
  final IconData icon;
  final Widget content;
  final Color? color;

  CustomStepperStep({
    required this.icon,
    required this.content,
    this.color,
  });
}