import 'package:flutter/material.dart';
import '../constants.dart';

class DirectoryModal extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const DirectoryModal({Key? key, required this.data}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DirectoryModalState createState() => _DirectoryModalState();
}

class _DirectoryModalState extends State<DirectoryModal> {
  List<Map<String, dynamic>> _currentData = [];
  final List<String> _selectedItems = [];
  String _currentPath = "";

  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
  }

  void _onItemSelected(int index) {
    setState(() {
      if (_currentData[index]['type'] == "directory") {
        _currentPath += "/${_currentData[index]['name']}";
        _currentData = (_currentData[index]['contents'] as List)
            .cast<Map<String, dynamic>>();
        _selectedItems.clear();
      } else {
        String fileName = _currentData[index]['name'];
        _selectedItems.clear();
        _selectedItems.add("$_currentPath/$fileName");
      }
    });
  }

  void _onBackButtonPressed() {
    setState(() {
      if (_currentPath.isNotEmpty) {
        _selectedItems.clear();
        int lastIndex = _currentPath.lastIndexOf("/");
        if (lastIndex == 0) {
          _currentPath = "";
          _currentData = widget.data;
        } else {
          _currentPath = _currentPath.substring(0, lastIndex);
          List<String> folders = _currentPath.split("/");
          folders.removeAt(0);
          _currentData = widget.data;
          for (String folder in folders) {
            _currentData = _currentData
                .where((item) => item['name'] == folder)
                .toList()
                .cast<Map<String, dynamic>>();
          }
          _currentData = (_currentData[0]["contents"] as List)
              .cast<Map<String, dynamic>>();
        }
      }
    });
  }

  void _onCancelButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onUploadButtonPressed(BuildContext context) {
    if (_selectedItems.isNotEmpty) {
      Navigator.of(context).pop(_selectedItems[0]);
    }
  }

  List<String> _getDirectories() {
    return _currentPath.split("/");
  }

  List<Widget> _generateDirectoryWidgets() {
    List<String> directories = _getDirectories();
    List<Widget> widgets = [];

    // Add home icon as the first widget
    widgets.add(const Icon(Icons.home));

    // Loop through the directories list and add forward arrow icon and text widget for each directory
    for (int i = 0; i < directories.length; i++) {
      widgets.add(
        Text(
          directories[i],
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: secondaryColor,
          ),
        ),
      );
      widgets.add(const Icon(Icons.arrow_forward_ios_rounded));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 1200,
        width: double.maxFinite,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _currentPath.isNotEmpty ? _onBackButtonPressed : null,
                  child: Icon(
                    Icons.arrow_back,
                    color: _currentPath.isNotEmpty
                        ? Colors.black
                        : Colors.black.withOpacity(0.4),
                    size: 48,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 20,
                      children: _generateDirectoryWidgets(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _currentData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _onItemSelected(index),
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: 15, top: 15, right: 15),
                      height: 150,
                      decoration: BoxDecoration(
                        border: _selectedItems.isEmpty
                            ? null
                            : _selectedItems[0].split("/").last ==
                                    _currentData[index]["name"]
                                ? Border.all(color: primaryColor, width: 3)
                                : null,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.25))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _currentData[index]["type"] == "directory"
                                  ? const Color(0XFFF7C327)
                                  : _currentData[index]["name"]
                                          .toString()
                                          .endsWith('.pdf')
                                      ? const Color(0xFFC50606)
                                      : const Color(0XFF295391),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              _currentData[index]["type"] == "directory"
                                  ? Icons.folder_copy_outlined
                                  : Icons.description_outlined,
                              size: 62,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  _currentData[index]["name"],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 32,
                                    color: secondaryColor,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                                Text(
                                  _currentData[index]["type"] == "directory"
                                      ? "${_currentData[index]["num_files"]} file${_currentData[index]["num_files"] > 1 ? 's' : ''}"
                                      : _currentData[index]["size"].toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: secondaryColor,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => _onCancelButtonPressed(context),
                  child: Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3, color: secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _selectedItems.isEmpty
                      ? null
                      : _onUploadButtonPressed(context),
                  child: Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _selectedItems.isEmpty
                          ? secondaryColor.withOpacity(0.25)
                          : primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () => _onCancelButtonPressed(context),
                //   child: Text("Cancel"),
                // ),
                // ElevatedButton(
                //   style: ButtonStyle(backgroundColor: _selectedItems.isEmpty ? secondaryColor : primaryColor)
                //   onPressed: () {
                //     print(_selectedItems);
                //   },
                //   // onPressed: () => _onUploadButtonPressed(context),
                //   child: Text("Upload"),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
