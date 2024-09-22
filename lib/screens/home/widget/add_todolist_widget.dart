import 'package:flutter/material.dart';

class AddTodolistWidget extends StatefulWidget {
  const AddTodolistWidget({super.key});

  @override
  State<AddTodolistWidget> createState() => _AddTodolistWidgetState();
}

class _AddTodolistWidgetState extends State<AddTodolistWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print('init');
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    print(_focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      // TextField가 포커스를 얻었을 때 수행할 작업
      print('TextField has focus');
    } else {
      // TextField가 포커스를 잃었을 때 수행할 작업
      print('TextField lost focus');
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Container(
          height: 42,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Color(0xFFECECF0),
            border: Border.all(
              color: Color(0xFFE2E2EA),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(35),
          ),
          child: TextField(
            focusNode: _focusNode,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              hintText: '할 일을 추가해 보세요.',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8892A6),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                  left: 15, bottom: 10), // Adjust padding as needed
            ),
          ),
        ),
      ),
    );
  }
}

// class _AddTodolistWidgetState extends State<AddTodolistWidget> {
//   final FocusNode _focusNode = FocusNode();
//   OverlayEntry? _overlayEntry;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_handleFocusChange);
//   }
//
//   @override
//   void dispose() {
//     _focusNode.removeListener(_handleFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   void _handleFocusChange() {
//     if (_focusNode.hasFocus) {
//       _showOverlay();
//     } else {
//       _removeOverlay();
//     }
//   }
//
//   void _showOverlay() {
//     _overlayEntry = _createOverlayEntry();
//     Overlay.of(context)?.insert(_overlayEntry!);
//   }
//
//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//
//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);
//
//     return OverlayEntry(
//       builder: (context) => GestureDetector(
//         onTap: () {
//           _focusNode.unfocus();
//         },
//         child: Stack(
//           children: [
//             Container(
//               color: Colors.black.withOpacity(0.5),
//             ),
//             Positioned(
//               left: offset.dx,
//               top: offset.dy,
//               width: size.width,
//               height: size.height,
//               child: Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFECECF0),
//                     border: Border.all(
//                       color: Color(0xFFE2E2EA),
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(35),
//                   ),
//                   child: TextField(
//                     focusNode: _focusNode,
//                     decoration: InputDecoration(
//                       hintText: '할 일을 추가해 보세요.',
//                       hintStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFF8892A6),
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.only(
//                           left: 15, bottom: 10), // Adjust padding as needed
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//       child: Container(
//         height: 42,
//         width: MediaQuery.of(context).size.width * 0.8,
//         decoration: BoxDecoration(
//           color: Color(0xFFECECF0),
//           border: Border.all(
//             color: Color(0xFFE2E2EA),
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(35),
//         ),
//         child: TextField(
//           focusNode: _focusNode,
//           decoration: InputDecoration(
//             hintText: '할 일을 추가해 보세요.',
//             hintStyle: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF8892A6),
//             ),
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.only(left: 15, bottom: 10),
//           ),
//         ),
//       ),
//     );
//   }
// }
