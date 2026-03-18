import 'package:flutter/material.dart';

typedef OnTimeRangeSelected = void Function(double hours, TimeOfDay start, TimeOfDay end);

class DayTimelinePicker extends StatefulWidget {
  final TimeOfDay? initialStart;
  final TimeOfDay? initialEnd;
  final OnTimeRangeSelected onTimeRangeSelected;
  final VoidCallback? onCleared;

  const DayTimelinePicker({
    super.key,
    this.initialStart,
    this.initialEnd,
    required this.onTimeRangeSelected,
    this.onCleared,
  });

  @override
  State<DayTimelinePicker> createState() => _DayTimelinePickerState();
}

class _DayTimelinePickerState extends State<DayTimelinePicker> {
  static const _startHour = 0;
  static const _endHour = 24;
  static const _hourHeight = 60.0;
  static const _labelWidth = 52.0;
  static const _quarterMinutes = 15;

  final _scrollController = ScrollController();
  TimeOfDay? _start;
  TimeOfDay? _end;

  // Drag state tracked via raw pointer events (Listener).
  Offset? _pointerStart;
  int? _dragStartSlot;
  bool _isDragging = false;
  static const _dragSlop = 6.0;

  // Edge auto-scroll during drag.
  static const _edgeZone = 48.0; // px from top/bottom edge to trigger scroll
  static const _scrollSpeed = 8.0; // px per tick
  int? _autoScrollTickerId;

  /// The visible height of the ConstrainedBox (captured on first layout).
  double _viewportHeight = 780;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialPosition();
    });
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll(double direction) {
    _stopAutoScroll();
    final id = (_autoScrollTickerId ?? 0) + 1;
    _autoScrollTickerId = id;
    _tickAutoScroll(id, direction);
  }

  void _tickAutoScroll(int id, double direction) {
    if (_autoScrollTickerId != id || !_isDragging) return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final newOffset = (pos.pixels + direction * _scrollSpeed)
        .clamp(pos.minScrollExtent, pos.maxScrollExtent);
    _scrollController.jumpTo(newOffset);

    // Update the selection to track the new scroll position.
    if (_pointerStart != null) {
      final slot = _slotFromY(
        _lastPointerY,
        _scrollController.offset,
      );
      _updateDragSelection(slot);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tickAutoScroll(id, direction);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTickerId = null;
  }

  double _lastPointerY = 0;

  void _scrollToInitialPosition() {
    if (!_scrollController.hasClients) return;
    double targetOffset;
    if (_start != null) {
      // Scroll so the selection start is visible near the top
      targetOffset = _timeToSlot(_start!).toDouble() * (_hourHeight / 4) - _hourHeight;
    } else {
      // Default to 6 AM so working hours (6 AM – 7 PM) are in view
      targetOffset = 6 * _hourHeight;
    }
    _scrollController.jumpTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
    );
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  double? get _calculatedHours {
    if (_start == null || _end == null) return null;
    return (_endMinutes(_end!) - _toMinutes(_start!)) / 60.0;
  }

  int _totalSlots() => (_endHour - _startHour) * 4;

  int _slotFromY(double localY, double scrollOffset) {
    final adjustedY = localY + scrollOffset;
    final slot = (adjustedY / (_hourHeight / 4)).floor();
    return slot.clamp(0, _totalSlots() - 1);
  }

  TimeOfDay _slotToTime(int slot) {
    final totalMinutes = (_startHour * 60) + slot * _quarterMinutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  /// Returns the time at the *end* of [slot] (i.e. slot start + 15 min).
  /// Caps at 24:00 represented as TimeOfDay(hour: 0, minute: 0) with
  /// _toMinutes returning 1440 via the helper below.
  TimeOfDay _slotEndTime(int slot) {
    final totalMinutes = (_startHour * 60) + (slot + 1) * _quarterMinutes;
    if (totalMinutes >= 1440) return const TimeOfDay(hour: 0, minute: 0);
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  /// Like [_toMinutes] but treats midnight-as-end-of-day as 1440.
  int _endMinutes(TimeOfDay t) {
    final m = t.hour * 60 + t.minute;
    return m == 0 && _start != null && _toMinutes(_start!) > 0 ? 1440 : m;
  }

  int _timeToSlot(TimeOfDay t) {
    return (_toMinutes(t) - _startHour * 60) ~/ _quarterMinutes;
  }

  // --- Raw pointer handlers (zero-delay drag) ---

  void _onPointerDown(PointerDownEvent event) {
    _pointerStart = event.localPosition;

    _dragStartSlot = _slotFromY(event.localPosition.dy, _scrollController.offset);
    _isDragging = false;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointerStart == null || _dragStartSlot == null) return;
    _lastPointerY = event.localPosition.dy;
    final dy = (event.localPosition.dy - _pointerStart!.dy).abs();
    if (!_isDragging && dy > _dragSlop) {
      setState(() {
        _isDragging = true;
        _start = _slotToTime(_dragStartSlot!);
        _end = null;
      });
    }
    if (_isDragging) {
      // Use the live scroll offset so the selection extends as auto-scroll moves.
      final slot = _slotFromY(event.localPosition.dy, _scrollController.offset);
      _updateDragSelection(slot);

      // Trigger edge auto-scroll when near top/bottom of viewport.
      if (event.localPosition.dy < _edgeZone) {
        _startAutoScroll(-1); // scroll up
      } else if (event.localPosition.dy > _viewportHeight - _edgeZone) {
        _startAutoScroll(1); // scroll down
      } else {
        _stopAutoScroll();
      }
    }
  }

  void _updateDragSelection(int slot) {
    setState(() {
      if (slot >= _dragStartSlot!) {
        _start = _slotToTime(_dragStartSlot!);
        _end = _slotEndTime(slot);
      } else {
        _start = _slotToTime(slot);
        _end = _slotEndTime(_dragStartSlot!);
      }
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    _stopAutoScroll();
    if (_isDragging) {
      // Finalise drag selection.
      if (_start != null && _end != null) {
        widget.onTimeRangeSelected(_calculatedHours!, _start!, _end!);
      }
    } else if (_dragStartSlot != null) {
      // No significant movement — treat as a tap.
      _handleTap(_dragStartSlot!);
    }
    _pointerStart = null;
    _dragStartSlot = null;
    _isDragging = false;
  }

  void _handleTap(int slot) {
    final tapped = _slotToTime(slot);
    setState(() {
      if (_start == null) {
        _start = tapped;
        _end = null;
      } else if (_end == null) {
        if (_toMinutes(tapped) >= _toMinutes(_start!)) {
          _end = _slotEndTime(slot);
          widget.onTimeRangeSelected(_calculatedHours!, _start!, _end!);
        } else {
          _start = tapped;
        }
      } else {
        _start = tapped;
        _end = null;
      }
    });
  }

  void _clear() {
    setState(() {
      _start = null;
      _end = null;
    });
    widget.onCleared?.call();
  }

  String _formatHourLabel(int hour) {
    if (hour == 0 || hour == 12) return '12 ${hour == 0 ? 'AM' : 'PM'}';
    return hour > 12 ? '${hour - 12} PM' : '$hour AM';
  }

  String _formatTime(TimeOfDay t, {bool isEnd = false}) {
    // Midnight used as end-of-day (24:00).
    if (isEnd && t.hour == 0 && t.minute == 0) return '12:00 AM';
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final min = t.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hours = _calculatedHours;
    final hasSelection = _start != null && _end != null;
    final totalHeight = (_endHour - _startHour) * _hourHeight;
    final dividerColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            Expanded(
              child: Text(
                hasSelection
                    ? '${hours!.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 2)} hours  (${_formatTime(_start!)} – ${_formatTime(_end!, isEnd: true)})'
                    : _start != null
                        ? 'Select end time'
                        : 'Tap or hold & drag to select time',
                style: theme.textTheme.titleSmall,
              ),
            ),
            if (hasSelection || _start != null)
              TextButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Timeline — shows ~13 hours (6 AM–7 PM) by default, scrollable for full day
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 780),
          child: LayoutBuilder(
            builder: (context, constraints) {
              _viewportHeight = constraints.maxHeight;
              return Listener(
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                height: totalHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hour labels column
                    SizedBox(
                      width: _labelWidth,
                      height: totalHeight,
                      child: Stack(
                        children: List.generate(_endHour - _startHour, (i) {
                          return Positioned(
                            top: i * _hourHeight - 7,
                            left: 0,
                            right: 4,
                            child: Text(
                              _formatHourLabel(_startHour + i),
                              textAlign: TextAlign.right,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    // Timeline area
                    Expanded(
                      child: Stack(
                        children: [
                          // Hour divider lines
                          ...List.generate(_endHour - _startHour + 1, (i) {
                            return Positioned(
                              top: i * _hourHeight,
                              left: 0,
                              right: 0,
                              child: Divider(height: 0.5, thickness: 0.5, color: dividerColor),
                            );
                          }),
                          // Half-hour dashed lines
                          ...List.generate(_endHour - _startHour, (i) {
                            return Positioned(
                              top: i * _hourHeight + _hourHeight / 2,
                              left: 0,
                              right: 0,
                              child: _DashedLine(color: dividerColor),
                            );
                          }),
                          // Selection overlay
                          if (_start != null) _buildSelectionOverlay(theme),
                          // Current time indicator
                          _buildNowIndicator(theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionOverlay(ThemeData theme) {
    final startSlot = _timeToSlot(_start!);
    final slotH = _hourHeight / 4;
    final top = startSlot * slotH;
    // _end is the *end* of the last selected slot, so convert via minutes.
    final endPx = _end != null
        ? _endMinutes(_end!) / _quarterMinutes * slotH
        : (startSlot + 1) * slotH;
    final height = endPx - top;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: height.clamp(slotH, double.infinity),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: _end != null
            ? Text(
                '${_formatTime(_start!)} – ${_formatTime(_end!, isEnd: true)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildNowIndicator(ThemeData theme) {
    final now = TimeOfDay.now();
    final nowMinutes = _toMinutes(now);
    final rangeStart = _startHour * 60;
    final rangeEnd = _endHour * 60;
    if (nowMinutes < rangeStart || nowMinutes > rangeEnd) {
      return const SizedBox.shrink();
    }
    final top = (nowMinutes - rangeStart) / 60.0 * _hourHeight;
    return Positioned(
      top: top - 4,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Divider(
              height: 1,
              thickness: 1.5,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A simple dashed horizontal line.
class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final count = (width / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(count, (_) {
            return SizedBox(
              width: dashWidth + dashSpace,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: dashWidth, height: 0.5, color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
