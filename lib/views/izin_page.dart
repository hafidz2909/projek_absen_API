// import 'package:flutter/material.dart';
// import 'package:projek_absen/service/auth_service.dart';

// class IzinAbsenPage extends StatefulWidget {
//   const IzinAbsenPage({Key? key}) : super(key: key);

//   @override
//   State<IzinAbsenPage> createState() => _IzinAbsenPageState();
// }

// class _IzinAbsenPageState extends State<IzinAbsenPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _alasanController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> _submitIzin() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });

//       try {
//         final authService = AuthService();
//         final success = await authService.izin(
//           alasan: _alasanController.text.trim(),
//         );
//         if (success == true) {
//           if (!mounted) return;
//           Navigator.pop(context, true);
//         } else {
//           setState(() {
//             _errorMessage = 'Gagal mengirim izin';
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _errorMessage = e.toString();
//         });
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _alasanController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ajukan Izin Absen')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               if (_errorMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Text(
//                     _errorMessage!,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ),
//               TextFormField(
//                 controller: _alasanController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText: "Alasan Izin",
//                   border: OutlineInputBorder(),
//                   alignLabelWithHint: true,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Alasan harus diisi";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                     onPressed: _submitIzin,
//                     child: const Text('Kirim Izin'),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
