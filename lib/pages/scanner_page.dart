import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ScannerPage({super.key, required this.cameras});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  CameraController? _controller;
  String _statusMessage = 'Ready to scan';
  String _detectedCode = '';
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
      try {
        await _controller!.initialize();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        print('Camera initialization error: $e');
      }
    }
  }

  Future<void> _scanCard() async {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        _isScanning = true;
        _statusMessage = 'Scanning...';
      });

      // Simulate detecting the 14-digit code (replace with OCR or image processing logic)
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _detectedCode = '78531234567890'; // Simulated 14-digit code
        _statusMessage = 'Code detected: $_detectedCode';
      });

      _rechargeWithUSSD();
    }
  }

  Future<void> _rechargeWithUSSD() async {
    if (_detectedCode.length == 14) {
      String ussdCode = 'tel:*202*$_detectedCode#';
      setState(() {
        _statusMessage = 'Initiating recharge with $ussdCode...';
      });

      // Simulate USSD call (for development/testing)
      await Future.delayed(Duration(seconds: 2));
      if (await Permission.phone.request().isGranted) {
        setState(() {
          _statusMessage = 'Recharge initiated successfully!';
        });
      } else {
        setState(() {
          _statusMessage = 'Permission denied for USSD call.';
        });
      }
    } else {
      setState(() {
        _statusMessage = 'Invalid code detected.';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller != null && _controller!.value.isInitialized
          ? Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(minHeight: 800),
              decoration: BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1603190287605-e6ade32fa852?q=80&w=1470&auto=format&fit=crop',
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.3,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.dstATop,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        margin: EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Color(0xFF111827).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFFF97316).withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(width: 8),
                            Row(
                              children: [
                                Icon(Icons.document_scanner, color: Color(0xFFF97316)),
                                SizedBox(width: 8),
                                Text(
                                  'Orange Card Scanner',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Stack(
                            children: [
                              CameraPreview(_controller!),
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFFF97316), width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: CustomPaint(
                                          size: Size(48, 48),
                                          painter: CornerPainter(topLeft: true),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: CustomPaint(
                                          size: Size(48, 48),
                                          painter: CornerPainter(topRight: true),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: CustomPaint(
                                          size: Size(48, 48),
                                          painter: CornerPainter(bottomLeft: true),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CustomPaint(
                                          size: Size(48, 48),
                                          painter: CornerPainter(bottomRight: true),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Color(0xFFF97316).withOpacity(0.3)),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Align card here',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      AnimatedPositioned(
                                        duration: Duration(seconds: 3),
                                        top: _isScanning ? 0 : -1,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFFFB923C), Color(0xFFF97316)],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Color(0xFF1F2937).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFF374151)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status:',
                              style: TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _statusMessage.contains('success') ? Colors.green : (_statusMessage.contains('error') ? Colors.red : Color(0xFFF97316)),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _statusMessage,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.flash_on, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1F2937),
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _scanCard,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.all(20),
                                shape: CircleBorder(),
                                shadowColor: Color(0xFFF97316).withOpacity(0.2),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                                  ),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Icon(Icons.camera, size: 32, color: Colors.white),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.settings, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1F2937),
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF1F2937).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF97316),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.smartphone, color: Colors.white, size: 16),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Orange Madagascar',
                                  style: TextStyle(
                                    color: Color(0xFFF97316),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Hold your Orange recharge card steady within the frame. Make sure it\'s well-lit and the code is clearly visible. The app will automatically detect and process the recharge code.',
                              style: TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Opacity(
                      opacity: 0.3,
                      child: SvgPicture.string(
                        '''
                        <svg width="40" height="40" viewBox="0 0 24 24">
                          <path fill="#F97316" d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4Z"/>
                        </svg>
                        ''',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class CornerPainter extends CustomPainter {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  CornerPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFF97316)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    if (topLeft) {
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
      canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
    }
    if (topRight) {
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    }
    if (bottomLeft) {
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
      canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
    }
    if (bottomRight) {
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}