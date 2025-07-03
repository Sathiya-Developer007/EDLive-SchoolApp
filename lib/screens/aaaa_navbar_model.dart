//   AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         toolbarHeight: 70,
//         automaticallyImplyLeading: false,
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu, color: Colors.black),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//         title: Row(
//           children: [
//             const Text(
//               'Ed',
//               style: TextStyle(
//                 color: Colors.indigo,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             const Text(
//               'Live',
//               style: TextStyle(
//                 color: Colors.lightBlue,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             const Spacer(),
//             SvgPicture.asset(
//               'assets/icons/notification.svg',
//               height: 24,
//               width: 24,
//               color: Colors.black,
//             ),
//             const SizedBox(width: 16),
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//               child: const CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 child: Icon(Icons.person, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
// entha appbar ah vachu change panny tha