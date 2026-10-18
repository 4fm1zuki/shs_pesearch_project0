import 'package:flutter/material.dart';
import 'donor_data.dart';
import 'local_demo_map.dart';

class BarangayMapView extends StatefulWidget {
  final String? selectedBarangay;
  final String selectedBloodType;
  final Function(String) onBarangaySelected;
  final ThemeMode themeMode; // Added to receive theme changes
  final TransformationController transformationController;

  const BarangayMapView({
    super.key,
    required this.selectedBarangay,
    required this.selectedBloodType,
    required this.onBarangaySelected,
    required this.themeMode,
    required this.transformationController,
  });

  @override
  State<BarangayMapView> createState() => _BarangayMapViewState();
}

class _BarangayMapViewState extends State<BarangayMapView> {
  // Canonical barangay name -> donor count
  Map<String, int> _barangayDonorCounts = {};

  bool _isLoading = true;
  bool _isMapLoading = true;

  // Prevent an older local filter operation from overwriting a newer one.
  int _requestVersion = 0;

  @override
  void initState() {
    super.initState();
    _initializeMapData();
  }

  @override
  void didUpdateWidget(covariant BarangayMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Refresh counts when the selected blood type changes.
    if (oldWidget.selectedBloodType != widget.selectedBloodType) {
      _fetchDonorCounts();
    }
  }

  bool _isDarkMode() {
    if (widget.themeMode == ThemeMode.dark) return true;
    if (widget.themeMode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  Future<void> _initializeMapData() async {
    await _fetchDonorCounts();
    if (!mounted) return;
    setState(() => _isMapLoading = false);
  }

  Future<void> _fetchDonorCounts() async {
    final int requestId = ++_requestVersion;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final counts = <String, int>{};
    for (final donor in DonorData.mockDonors) {
      if (widget.selectedBloodType != 'ALL' &&
          donor['bloodType'] != widget.selectedBloodType) {
        continue;
      }
      final barangay = donor['location'];
      if (barangay != null) {
        counts[barangay] = (counts[barangay] ?? 0) + 1;
      }
    }

    if (requestId == _requestVersion && mounted) {
      setState(() {
        _barangayDonorCounts = counts;
        _isLoading = false;
      });
    }
  }

  void _selectBarangay(String barangay) {
    final bool alreadySelected = widget.selectedBarangay == barangay;
    widget.onBarangaySelected(alreadySelected ? '' : barangay);
  }

  Widget _buildMapLegend(Color cardColor, Color textColor) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: Card(
        color: cardColor,
        elevation: 4,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AVAILABLE DONORS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              _legendItem(
                _isDarkMode()
                    ? const Color(0x25FFFFFF)
                    : const Color(0x15000000),
                'No available donors',
                textColor,
              ),
              const SizedBox(height: 5),
              _legendItem(
                const Color(0x66B41E23),
                'Available donors',
                textColor,
              ),
              const SizedBox(height: 5),
              _legendItem(
                const Color(0x667A1C1E),
                'Selected barangay',
                textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: const Color(0xFF7A1C1E),
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: textColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedBarangayCard(Color cardColor, Color textColor) {
    final String? barangay = widget.selectedBarangay;

    if (barangay == null || barangay.isEmpty) {
      return const SizedBox.shrink();
    }

    final int count = _barangayDonorCounts[barangay] ?? 0;

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Center(
        child: Card(
          color: cardColor,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: Color(0xFF7A1C1E),
                ),
                const SizedBox(width: 8),
                Text(
                  barangay,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE4E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count available',
                    style: const TextStyle(
                      color: Color(0xFFB42318),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = _isDarkMode();

    final cardColor = isDark ? const Color(0xFF292929) : Colors.white;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          LocalDemoMap(
            selectedBarangay: widget.selectedBarangay,
            donorCounts: _barangayDonorCounts,
            transformationController: widget.transformationController,
            onBarangaySelected: _selectBarangay,
          ),

          // Header
          Positioned(
            top: 16,
            left: 16,
            child: Card(
              color: cardColor,
              elevation: 4,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DIGOS CITY BARANGAY MAP',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Color(0xFF7A1C1E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.selectedBloodType == 'ALL'
                          ? 'All available donors'
                          : '${widget.selectedBloodType} available donors',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Selected barangay information.
          _buildSelectedBarangayCard(cardColor, textColor),

          // Legend
          _buildMapLegend(cardColor, textColor),

          // Loading indicator.
          if (_isLoading || _isMapLoading)
            Positioned(
              top: 16,
              right: 16,
              child: Card(
                color: cardColor,
                elevation: 4,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _isMapLoading ? 'Loading map...' : 'Syncing donors...',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
