import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _oldAddress = '';
  String _oldReceiver = '';
  String _oldPhone = '';

  @override
  void initState() {
    super.initState();
    _loadAddressInfo();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _receiverController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadAddressInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        setState(() {
          _oldAddress = userData['address'];
          _oldReceiver = userData['receiver'];
          _oldPhone = userData['phone'];

          _addressController.text = _oldAddress;
          _receiverController.text = _oldReceiver;
          _phoneController.text = _oldPhone;
        });
      }
    }
  }

  void _saveAddressInfo() async {
    if (_formKey.currentState!.validate()) {
      String newAddress = _addressController.text;
      String newReceiver = _receiverController.text;
      String newPhone = _phoneController.text;

      if (newAddress == _oldAddress &&
          newReceiver == _oldReceiver &&
          newPhone == _oldPhone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No changes made'),
          ),
        );
      } else {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'address': newAddress,
            'receiver': newReceiver,
            'phone': newPhone,
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Delivery Information updated!'),
            ),
          );
        }

        Navigator.pop(context); // Go back to the previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Delivery Information',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        leadingWidth: 70,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                _buildAddressField(),
                const SizedBox(
                  height: 20,
                ),
                _buildReceiverField(),
                const SizedBox(
                  height: 20,
                ),
                _buildPhoneField(),
                const SizedBox(
                  height: 50,
                ),
                _saveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildReceiverField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receiver',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _receiverController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the receiver\'s name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            hintText: 'eg: 012 3456789',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            } else if (value.length < 10) {
              return 'Phone number must be at least 10 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA3D5D4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: _saveAddressInfo,
      child: const Text(
        "Save",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
