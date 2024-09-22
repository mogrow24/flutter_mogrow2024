import 'package:flutter/material.dart';

class ShowModalDescription extends StatefulWidget {
  final String initDesc;

  const ShowModalDescription({super.key, required this.initDesc});

  @override
  State<ShowModalDescription> createState() => _ShowModalDescriptionState();
}

class _ShowModalDescriptionState extends State<ShowModalDescription> {
  // text 관련
  final TextEditingController _controllerDesc = TextEditingController();
  int _characterCountDesc = 0;
  final int _maxLengthDesc = 120;
  final int _maxLines = 8;
  final FocusNode _descFocus = FocusNode();

  // 필수 항목 체크
  bool? checkDesc;

  // 유효성 검사 함수
  bool _validateInputs() {
    setState(() {
      checkDesc = _controllerDesc.text.isEmpty ? false : true;
    });

    return checkDesc != false;
  }

  // 텍스트 입력 시 카운트
  void _updateCharacterCount() {
    setState(() {
      _characterCountDesc = _controllerDesc.text.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerDesc.text = widget.initDesc;
    _characterCountDesc = widget.initDesc.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _descFocus.unfocus();
      },
      child: SafeArea(
        // child: Scaffold(
        //   backgroundColor: Colors.white,
        //   appBar: AppBar(
        //     title: Text(
        //       '설명',
        //       style: TextStyle(
        //         color: Color(0xFF14161A),
        //         fontWeight: FontWeight.w600,
        //         fontSize: 20,
        //       ),
        //     ),
        //     centerTitle: true,
        //     leading: TextButton(
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //       child: Image.asset(
        //         'assets/icons/arrow_down.png',
        //         width: 40,
        //         height: 40,
        //       ),
        //     ),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           if (_characterCountDesc > 0) {
        //             print('완료');
        //           }
        //         },
        //         style: ButtonStyle(
        //           overlayColor: WidgetStateProperty.all(Colors.white),
        //         ),
        //         child: _validateInputs()
        //             ? Image.asset(
        //           'assets/icons/check.png',
        //           color: Color(0xFF0066FA),
        //           width: 40,
        //           height: 40,
        //         )
        //             : Image.asset(
        //           'assets/icons/check.png',
        //           color: Colors.grey,
        //           width: 40,
        //           height: 40,
        //         ),
        //       ),
        //     ],
        //   ),
        //   body: Container(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xffF6F6F8),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 50,
              ),
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('');
                      },
                      child: Image.asset(
                        'assets/icons/close.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Text(
                      '설명',
                      style: TextStyle(
                        color: Color(0xFF14161A),
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_characterCountDesc > 0) {
                          Navigator.of(context).pop(_controllerDesc.text);
                        }
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: _validateInputs()
                          ? Image.asset(
                              'assets/icons/check.png',
                              color: Color(0xFF0066FA),
                              width: 40,
                              height: 40,
                            )
                          : Image.asset(
                              'assets/icons/check.png',
                              color: Colors.grey,
                              width: 40,
                              height: 40,
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 140,
                          child: TextField(
                            focusNode: _descFocus,
                            controller: _controllerDesc,
                            maxLength: _maxLengthDesc,
                            maxLines: _maxLines,
                            decoration: InputDecoration(
                              hintText: '설명',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8892A6),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              counterText:
                                  '$_characterCountDesc/$_maxLengthDesc',
                              counterStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8892A6),
                              ),
                            ),
                            style: TextStyle(
                              color: Color(0xFF14161A),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (text) {
                              _updateCharacterCount();
                            },
                            autofocus: true,
                            // textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
